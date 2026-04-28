#!/usr/bin/env python3
import sys, json, subprocess

data = json.load(sys.stdin)
event = data.get("hook_event_name", "")

if event == "Notification":
    title = data.get("title") or "Claude Code"
    msg = data.get("message", "needs attention")
elif event == "SubagentStop":
    agent = data.get("agent_type", "")
    title = f"Claude Code [{agent}]" if agent else "Claude Code"
    msg = data.get("last_assistant_message", "subagent finished")
elif event == "Stop":
    title = "Claude Code"
    msg = data.get("last_assistant_message", "finished")
else:
    title = "Claude Code"
    msg = "needs attention"

msg = msg.replace("\n", " ")[:200]

subprocess.run([
    "terminal-notifier",
    "-title", title,
    "-message", msg,
    "-activate", "org.alacritty",
    "-sound", "default",
])
