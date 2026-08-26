import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";
import { Container, Text } from "@oh-my-pi/pi-tui";

// /diff —— 零 LLM 查看当前仓库改动(彩色渲染,跟随主题)
// 用法: /diff            git status + git diff HEAD(staged + unstaged)
//       /diff --staged   透传任意 git diff 参数
//
// 结果以 custom message 写入会话,由下方 renderer 在 TUI 里上色。
// custom message 默认不参与 LLM 请求,整条链路不消耗任何 token。

const CUSTOM_TYPE = "git-diff-view";
/** 单条 diff 渲染的最大行数,超出部分截断并提示 */
const MAX_DIFF_LINES = 600;

interface DiffDetails {
  status: string;
  diff: string;
  truncated: number;
}

type ColorKey =
  | "muted" | "dim" | "accent" | "success" | "error"
  | "toolDiffAdded" | "toolDiffRemoved" | "toolDiffContext";

// git status --short:前两列 XY 分别是 staged / unstaged 状态
function classifyStatusLine(line: string): ColorKey {
  if (line.startsWith("##")) return "accent";
  if (line.startsWith("??")) return "error";
  const x = line.charAt(0) || " ";
  const y = line.charAt(1) || " ";
  if (x !== " ") return "success"; // staged
  if (y !== " ") return "error"; // unstaged
  return "muted";
}

function classifyDiffLine(line: string): ColorKey {
  if (line.startsWith("+++ ") || line.startsWith("--- ")) return "muted";
  if (line.startsWith("@@")) return "accent";
  if (line.startsWith("+")) return "toolDiffAdded";
  if (line.startsWith("-")) return "toolDiffRemoved";
  if (
    /^(diff --git |index |new file |deleted file |similarity |rename |old mode |new mode |Binary )/.test(
      line,
    )
  )
    return "dim";
  return "toolDiffContext";
}

/** 把连续同色的行合并,减少组件数量 */
function groupRuns(
  lines: string[],
  classify: (line: string) => ColorKey,
): Array<{ color: ColorKey; text: string }> {
  const runs: Array<{ color: ColorKey; text: string }> = [];
  for (const line of lines) {
    const color = classify(line);
    const last = runs[runs.length - 1];
    if (last && last.color === color) last.text += "\n" + line;
    else runs.push({ color, text: line });
  }
  return runs;
}

export default function (pi: ExtensionAPI) {
  pi.registerMessageRenderer<DiffDetails>(CUSTOM_TYPE, (message, _options, theme) => {
    const details = message.details;
    if (!details) return undefined;
    const container = new Container();
    for (const run of groupRuns(details.status.split("\n"), classifyStatusLine)) {
      container.addChild(new Text(theme.fg(run.color, run.text), 1, 0));
    }
    container.addChild(new Text("", 0, 0));
    for (const run of groupRuns(details.diff.split("\n"), classifyDiffLine)) {
      container.addChild(new Text(theme.fg(run.color, run.text), 1, 0));
    }
    if (details.truncated > 0) {
      container.addChild(
        new Text(
          theme.fg("dim", `… 其余 ${details.truncated} 行已截断,可 /diff <file> 查看单个文件`),
          1,
          0,
        ),
      );
    }
    return container;
  });

  pi.registerCommand("diff", {
    description: "查看当前仓库 diff(零 LLM,纯 git)",
    handler: async (rawArgs, ctx) => {
      const run = (args: string[]) => pi.exec("git", args, { cwd: ctx.cwd });

      const status = await run(["status", "--short", "--branch"]);
      if (status.code !== 0) {
        ctx.ui.notify(status.stderr.trim() || "git status 失败", "error");
        return;
      }

      const extra = rawArgs.trim().split(/\s+/).filter(Boolean);
      let diff = await run(["diff", ...(extra.length ? extra : ["HEAD"])]);
      if (diff.code !== 0 && extra.length === 0) {
        // 新仓库还没有 HEAD 提交,退化为普通 working-tree diff
        diff = await run(["diff"]);
      }
      if (diff.code !== 0) {
        ctx.ui.notify(diff.stderr.trim() || "git diff 失败", "error");
        return;
      }

      const statusText = status.stdout.trimEnd();
      const body = diff.stdout.trimEnd();
      if (!body) {
        const hasUntracked = statusText.split("\n").some(l => l.startsWith("??"));
        ctx.ui.notify(
          hasUntracked ? "没有已跟踪文件的改动(存在未跟踪文件)" : "工作区干净,没有改动",
          "info",
        );
        return;
      }

      let diffText = body;
      let truncated = 0;
      const lines = body.split("\n");
      if (lines.length > MAX_DIFF_LINES) {
        diffText = lines.slice(0, MAX_DIFF_LINES).join("\n");
        truncated = lines.length - MAX_DIFF_LINES;
      }

      if (!ctx.hasUI) {
        ctx.ui.notify(`${statusText}\n\n${diffText}`.slice(0, 2000), "info");
        return;
      }

      if (!ctx.isIdle()) await ctx.waitForIdle();
      const files = (body.match(/^diff --git /gm) ?? []).length;
      pi.sendMessage({
        customType: CUSTOM_TYPE,
        content:
          `git diff:${files} 个文件改动` +
          (truncated ? `(仅展示前 ${MAX_DIFF_LINES} 行)` : "") +
          (extra.length ? ` [${extra.join(" ")}]` : ""),
        display: true,
        details: { status: statusText, diff: diffText, truncated },
      });
    },
  });
}
