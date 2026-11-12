#!/bin/zsh
# Resolve the active metarouter API key.
#
# Source order:
#   1. macOS Keychain — service name from ~/.omp/metarouter-key (default
#      pi/metarouter), switched with `ompkey <name>` (see zshrc).
#   2. Fallback file ~/.omp/metarouter-key-value (0600), two lines:
#      service name, then key. Used only when its service matches the active
#      one. Needed because the login keychain's unlock state is per-session:
#      an SSH session (or a fresh boot before unlocking) reads nothing from
#      the keychain while the GUI session reads fine.
#
# Consumers: zshrc (METAROUTER_API_KEY for the Codex CLI) and the
# codex-environment LaunchAgent. OMP's models.yml reads Keychain directly and
# does not use this script.
# Must never depend on $USER: launchd agents and other stripped environments
# run this with USER unset, and `set -u` would then abort with an empty key,
# which surfaces as an empty METAROUTER_API_KEY (Codex "no API key") and
# ompkey "keychain 读取失败".
set -u
pointer="$HOME/.omp/metarouter-key"
fallback="$HOME/.omp/metarouter-key-value"
service="${1:-}"
if [[ -z "$service" && -r "$pointer" ]]; then
  read -r service < "$pointer"
fi
service="${service:-pi/metarouter}"

account="$(/usr/bin/id -un)"
key="$(/usr/bin/security find-generic-password -a "$account" -s "$service" -w 2>/dev/null)"
# Fall back to a service-only lookup: the item may have been created under a
# different account attribute (e.g. re-added after a key rotation).
if [[ -z "$key" ]]; then
  key="$(/usr/bin/security find-generic-password -s "$service" -w 2>/dev/null)"
fi

source_used="keychain"
if [[ -z "$key" ]]; then
  fb_service=""
  fb_key=""
  if [[ -r "$fallback" ]]; then
    { read -r fb_service; read -r fb_key; } < "$fallback"
    if [[ "$fb_service" == "$service" && -n "$fb_key" ]]; then
      key="$fb_key"
      source_used="fallback:$fallback"
    fi
  fi
fi

if [[ -z "$key" ]]; then
  print -u2 "metarouter-key: keychain 读取失败: $service (account=$account)"
  if [[ -r "$fallback" ]]; then
    print -u2 "metarouter-key: 兜底文件 $fallback 的服务是 '${fb_service:-<空>}'，与 '$service' 不匹配；在图形会话的终端里跑一次 ompkey $service 可刷新它"
  else
    print -u2 "metarouter-key: 兜底文件 $fallback 不存在；在图形会话的终端里跑一次 ompkey $service 可生成"
  fi
  exit 1
fi
print -r -- "$key"
