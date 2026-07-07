import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import { existsSync, readFileSync } from "node:fs";
import { basename, dirname, join, relative, sep } from "node:path";
import { execFileSync } from "node:child_process";

/**
 * Pi HUD
 *
 * Converted from the current Claude HUD config:
 * - display.showTools: true
 * - display.showAgents: false
 * - display.showTodos: true
 * - display.showDuration: true
 * - display.showConfigCounts: true
 * - display.usageBarEnabled: true
 * - display.customLine: "Human, Do you desire power?"
 * - gitStatus.enabled: false
 */

const HUD_CONFIG = {
  pathLevels: 1,
  display: {
    showTools: true,
    showAgents: false,
    showTodos: true,
    showDuration: true,
    showConfigCounts: true,
    showContextBar: true,
    usageBarEnabled: true,
    customLine: "Human, Do you desire power?",
  },
  gitStatus: {
    enabled: false,
    showDirty: false,
    showAheadBehind: false,
    showFileStats: false,
  },
};

type ToolState = {
  running: Map<string, { name: string; label: string }>;
  counts: Map<string, number>;
  lastStarted?: string;
};

const toolState: ToolState = {
  running: new Map(),
  counts: new Map(),
};

let sessionStartedAt = Date.now();
let currentTui: { requestRender(): void } | undefined;
let refreshTimer: ReturnType<typeof setInterval> | undefined;

function fmtNumber(n: number): string {
  if (!Number.isFinite(n)) return "0";
  if (n >= 1_000_000) return `${(n / 1_000_000).toFixed(1)}M`;
  if (n >= 1_000) return `${(n / 1_000).toFixed(n >= 10_000 ? 0 : 1)}k`;
  return String(Math.round(n));
}

function fmtDuration(ms: number): string {
  const totalSeconds = Math.max(0, Math.floor(ms / 1000));
  const hours = Math.floor(totalSeconds / 3600);
  const minutes = Math.floor((totalSeconds % 3600) / 60);
  const seconds = totalSeconds % 60;
  if (hours > 0) return `${hours}h ${minutes}m`;
  if (minutes > 0) return `${minutes}m`;
  return `${seconds}s`;
}

function findGitRoot(cwd: string): string | undefined {
  try {
    return execFileSync("git", ["rev-parse", "--show-toplevel"], {
      cwd,
      encoding: "utf8",
      stdio: ["ignore", "pipe", "ignore"],
      timeout: 200,
    }).trim();
  } catch {
    return undefined;
  }
}

function getProjectPath(cwd: string): string {
  const root = findGitRoot(cwd) ?? cwd;
  const rel = relative(dirname(root), root) || basename(root);
  const parts = rel.split(sep).filter(Boolean);
  return parts.slice(-HUD_CONFIG.pathLevels).join("/") || basename(root) || cwd;
}

function contextFilesCount(cwd: string): number {
  const root = findGitRoot(cwd);
  let dir = cwd;
  let count = 0;

  while (true) {
    if (existsSync(join(dir, "AGENTS.md"))) count++;
    if (existsSync(join(dir, "CLAUDE.md"))) count++;

    if (root && dir === root) break;
    const parent = dirname(dir);
    if (parent === dir) break;
    dir = parent;
  }

  return count;
}

function availableSkillsCount(ctx: ExtensionContext): number {
  try {
    const prompt = ctx.getSystemPrompt();
    const matches = prompt.match(/<skill>/g);
    return matches?.length ?? 0;
  } catch {
    return 0;
  }
}

function formatContextBar(percent: number | null | undefined, width = 10): string {
  if (percent === null || percent === undefined) return "░".repeat(width);
  const clamped = Math.max(0, Math.min(100, percent));
  const filled = Math.round((clamped / 100) * width);
  return "█".repeat(filled) + "░".repeat(Math.max(0, width - filled));
}

function latestAssistantUsage(ctx: ExtensionContext): { input: number; output: number; cost: number } {
  let input = 0;
  let output = 0;
  let cost = 0;

  for (const entry of ctx.sessionManager.getBranch()) {
    if (entry.type !== "message" || entry.message.role !== "assistant") continue;
    const usage = (entry.message as any).usage;
    input += usage?.input ?? 0;
    output += usage?.output ?? 0;
    cost += usage?.cost?.total ?? 0;
  }

  return { input, output, cost };
}

function formatToolsLine(theme: any): string | undefined {
  if (!HUD_CONFIG.display.showTools) return undefined;

  const parts: string[] = [];
  for (const { name, label } of toolState.running.values()) {
    parts.push(theme.fg("accent", `◐ ${label || name}`));
  }

  for (const [name, count] of toolState.counts) {
    parts.push(theme.fg("success", `✓ ${name} ×${count}`));
  }

  if (parts.length === 0) return undefined;
  return parts.join(theme.fg("dim", " | "));
}

function findTodoFile(cwd: string): string | undefined {
  const root = findGitRoot(cwd) ?? cwd;
  const candidates = [
    join(root, "TODO.md"),
    join(root, "TODO"),
    join(root, "todo.md"),
    join(cwd, "TODO.md"),
  ];
  return candidates.find((file) => existsSync(file));
}

function formatTodosLine(cwd: string, theme: any): string | undefined {
  if (!HUD_CONFIG.display.showTodos) return undefined;

  const file = findTodoFile(cwd);
  if (!file) return undefined;

  let content = "";
  try {
    content = readFileSync(file, "utf8");
  } catch {
    return undefined;
  }

  const tasks = content
    .split(/\r?\n/)
    .map((line) => /^\s*[-*]\s+\[([ xX])\]\s+(.+?)\s*$/.exec(line))
    .filter((match): match is RegExpExecArray => Boolean(match));

  if (tasks.length === 0) return undefined;

  const done = tasks.filter((match) => match[1].toLowerCase() === "x").length;
  const next = tasks.find((match) => match[1] === " ")?.[2] ?? "All todos complete";
  return `${theme.fg("accent", "▸")} ${theme.fg("text", next)} ${theme.fg("dim", `(${done}/${tasks.length})`)}`;
}

function fitLine(line: string, width: number): string {
  return truncateToWidth(line, width, "");
}

function oneDarkOrange(text: string): string {
  return `\x1b[38;2;209;154;102m${text}\x1b[39m`;
}

function padBetween(left: string, right: string, width: number): string {
  const pad = " ".repeat(Math.max(1, width - visibleWidth(left) - visibleWidth(right)));
  return fitLine(left + pad + right, width);
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => {
    sessionStartedAt = Date.now();
    toolState.running.clear();
    toolState.counts.clear();
    toolState.lastStarted = undefined;

    ctx.ui.setFooter((tui, theme) => {
      currentTui = tui;

      return {
        dispose() {
          if (currentTui === tui) currentTui = undefined;
        },
        invalidate() {},
        render(width: number): string[] {
          const usage = ctx.getContextUsage();
          const sessionUsage = latestAssistantUsage(ctx);
          const project = getProjectPath(ctx.cwd);
          const model = ctx.model ? ctx.model.id : "no-model";
          const contextPercent = usage?.percent ?? null;
          const contextBar = formatContextBar(contextPercent, HUD_CONFIG.display.usageBarEnabled ? 10 : 0);
          const contextText = contextPercent === null ? "ctx --" : `ctx ${Math.round(contextPercent)}%`;

          const contextFiles = HUD_CONFIG.display.showConfigCounts ? contextFilesCount(ctx.cwd) : 0;
          const skills = HUD_CONFIG.display.showConfigCounts ? availableSkillsCount(ctx) : 0;
          const configBits: string[] = [];
          if (contextFiles > 0) configBits.push(`${contextFiles} ctx`);
          if (skills > 0) configBits.push(`${skills} skills`);

          const leftParts = [
            theme.fg("accent", `[${model}]`),
            theme.fg("warning", project),
            HUD_CONFIG.display.showContextBar
              ? `${theme.fg("success", contextBar)} ${theme.fg("dim", contextText)}`
              : theme.fg("dim", contextText),
          ];

          if (HUD_CONFIG.display.showDuration) {
            leftParts.push(theme.fg("dim", `⏱ ${fmtDuration(Date.now() - sessionStartedAt)}`));
          }

          if (configBits.length > 0) {
            leftParts.push(theme.fg("dim", configBits.join(" ")));
          }

          const rightParts = [
            theme.fg("dim", `↑${fmtNumber(sessionUsage.input)}`),
            theme.fg("dim", `↓${fmtNumber(sessionUsage.output)}`),
          ];
          if (sessionUsage.cost > 0) {
            rightParts.push(theme.fg("dim", `$${sessionUsage.cost.toFixed(3)}`));
          }

          const separator = theme.fg("dim", " │ ");
          const main = padBetween(leftParts.join(separator), rightParts.join(" "), width);

          const lines = [main];

          const toolsLine = formatToolsLine(theme);
          if (toolsLine) lines.push(fitLine(toolsLine, width));

          if (HUD_CONFIG.display.showAgents) {
            lines.push(fitLine(theme.fg("dim", ctx.isIdle() ? "agent idle" : "agent running"), width));
          }

          const todosLine = formatTodosLine(ctx.cwd, theme);
          if (todosLine) lines.push(fitLine(todosLine, width));

          if (HUD_CONFIG.display.customLine) {
            lines.push(fitLine(oneDarkOrange(HUD_CONFIG.display.customLine), width));
          }

          return lines;
        },
      };
    });

    if (refreshTimer) clearInterval(refreshTimer);
    refreshTimer = setInterval(() => currentTui?.requestRender(), 1000);
  });

  pi.on("agent_start", async () => {
    toolState.running.clear();
    toolState.counts.clear();
    toolState.lastStarted = undefined;
    currentTui?.requestRender();
  });

  pi.on("tool_execution_start", async (event) => {
    const label = event.toolName;
    toolState.running.set(event.toolCallId, { name: event.toolName, label });
    toolState.lastStarted = event.toolName;
    currentTui?.requestRender();
  });

  pi.on("tool_execution_end", async (event) => {
    toolState.running.delete(event.toolCallId);
    toolState.counts.set(event.toolName, (toolState.counts.get(event.toolName) ?? 0) + 1);
    currentTui?.requestRender();
  });

  pi.on("agent_end", async () => {
    toolState.running.clear();
    currentTui?.requestRender();
  });

  pi.on("session_shutdown", async () => {
    if (refreshTimer) {
      clearInterval(refreshTimer);
      refreshTimer = undefined;
    }
    currentTui = undefined;
  });
}
