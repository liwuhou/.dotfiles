import { appendFileSync } from "node:fs";

import type { HookAPI } from "@oh-my-pi/pi-coding-agent/extensibility/hooks";

/**
 * 并行复核：长任务尚未委派时提醒检查剩余工作是否真能切成独立任务。
 *
 * 零 LLM 成本——只数工具调用的次数与名字，不做任何模型判断：
 *   - 触发：距上次 `task` 委派累计 >= 阈值 次工具调用，且其中 >= MIN_EDITS 次是编辑/写入；
 *   - 阈值逐级放大（默认 60 / 150 / 400），每次触发后重新计数，一个会话最多提醒 3 次；
 *   - 只在会话确实带 `task` 工具（顶层的交互会话）时生效，只读/受限会话不受影响；
 *   - 提醒走 `additionalContext`：不污染工具输出，按 developer 优先级在下一轮请求前送达。
 *
 * 环境变量（调试用）：
 *   OMP_PARALLEL_NUDGE_AFTER=60,150,400   阈值序列
 *   OMP_PARALLEL_NUDGE_MIN_EDITS=2        触发前至少编辑过几个文件
 *   OMP_PARALLEL_NUDGE_LOG=/tmp/pn.log    把加载/跳过/注入的判定追加写进文件（默认不写）
 */

const DEFAULT_THRESHOLDS = [60, 150, 400];
const DEFAULT_MIN_EDITS = 2;

/** 委派类工具：命中即视为"这次真的并行/委派过"，计数清零 */
const DELEGATE_TOOLS: Record<string, true> = { task: true, agent: true, workpool: true };
/** 写面工具：只有真在改东西才值得提醒，纯读的排查不该被打断 */
const EDIT_TOOLS: Record<string, true> = { edit: true, write: true, ast_edit: true };

function readThresholds(): number[] {
  const raw = process.env.OMP_PARALLEL_NUDGE_AFTER;
  if (!raw) return DEFAULT_THRESHOLDS;
  const parsed = raw
    .split(",")
    .map((part) => Number.parseInt(part.trim(), 10))
    .filter((value) => Number.isFinite(value) && value > 0);
  return parsed.length > 0 ? parsed : DEFAULT_THRESHOLDS;
}

function readMinEdits(): number {
  const raw = Number.parseInt(process.env.OMP_PARALLEL_NUDGE_MIN_EDITS ?? "", 10);
  return Number.isFinite(raw) && raw >= 0 ? raw : DEFAULT_MIN_EDITS;
}

function nudgeText(limit: number, edits: number): string {
  return [
    `[并行复核] 距上次委派子代理已经过了 ${limit} 次工具调用（其中 ${edits} 次是编辑/写入）。`,
    "检查剩余工作：若还有至少两个互不依赖的切片，分别界定目标、独占写面与验收方式，",
    "再用一次 task 的 tasks[] 批量并行下发。若只剩单线工作或依赖链，继续由主代理完成，不必为并发硬拆。",
  ].join("");
}

export default function parallelNudge(pi: HookAPI): void {
  const thresholds = readThresholds();
  const minEdits = readMinEdits();
  const debugPath = process.env.OMP_PARALLEL_NUDGE_LOG;

  let sinceDelegate = 0;
  let edits = 0;
  let fired = 0;
  let canDelegate: boolean | undefined;

  const trace = (line: string): void => {
    if (debugPath) {
      try {
        appendFileSync(debugPath, `${new Date().toISOString()} ${line}\n`);
      } catch {
        // 调试文件写不进去也不影响任何事
      }
    }
    try {
      pi.logger?.info?.("parallel-nudge", line);
    } catch {
      // 记日志失败不影响任何事
    }
  };

  trace(`loaded: thresholds=${thresholds.join("/")} minEdits=${String(minEdits)}`);

  const reset = (): void => {
    sinceDelegate = 0;
    edits = 0;
  };

  pi.on("session_start", () => {
    reset();
    fired = 0;
    canDelegate = undefined;
    trace("session_start: counters reset");
  });

  pi.on("tool_call", (event) => {
    try {
      if (canDelegate === undefined) {
        const tools = pi.getActiveTools?.() ?? [];
        canDelegate = tools.includes("task");
        trace(`active tools=${String(tools.length)}; canDelegate=${String(canDelegate)}`);
      }
      if (!canDelegate) return;

      if (DELEGATE_TOOLS[event.toolName] === true) {
        reset();
        trace(`delegated via ${event.toolName}: counters reset`);
        return;
      }

      sinceDelegate += 1;
      if (EDIT_TOOLS[event.toolName] === true) edits += 1;

      if (fired >= thresholds.length) return;
      const limit = thresholds[fired] as number;
      if (sinceDelegate < limit || edits < minEdits) return;

      const edited = edits;
      fired += 1;
      reset();
      trace(`injected #${String(fired)} after ${String(limit)} tool calls / ${String(edited)} edits`);
      return { additionalContext: nudgeText(limit, edited) };
    } catch (error) {
      trace(`failed: ${String(error)}`);
      return;
    }
  });
}
