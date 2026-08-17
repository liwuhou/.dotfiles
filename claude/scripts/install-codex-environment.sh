#!/bin/sh
set -eu

label="com.awu.codex-environment"
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source_plist="$script_dir/codex-environment.plist"
target_dir="$HOME/Library/LaunchAgents"
target_plist="$target_dir/$label.plist"
uid=$(id -u)
service="gui/$uid/$label"

mkdir -p "$target_dir"
install -m 644 "$source_plist" "$target_plist"
plutil -lint "$target_plist"
launchctl unsetenv METAROUTER_API_KEY 2>/dev/null || true
launchctl bootout "$service" 2>/dev/null || true
launchctl bootstrap "gui/$uid" "$target_plist"
launchctl kickstart -k "$service"

attempt=0
while [ "$attempt" -lt 10 ]; do
  if [ -n "$(launchctl getenv METAROUTER_API_KEY)" ]; then
    echo "installed $label"
    exit 0
  fi
  attempt=$((attempt + 1))
  sleep 1
done

echo "failed to inject METAROUTER_API_KEY" >&2
exit 1

