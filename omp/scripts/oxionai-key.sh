#!/bin/zsh
# Resolve the oxionai relay API key from the macOS Keychain.
# Keychain item: service "oxionai-primary" (created with `ompkey`-style tooling).
# Override the service name with $1 when testing another keychain item.
set -u
service="${1:-oxionai-primary}"
account="$(/usr/bin/id -un)"
key="$(/usr/bin/security find-generic-password -a "$account" -s "$service" -w 2>/dev/null)"
if [[ -z "$key" ]]; then
  key="$(/usr/bin/security find-generic-password -s "$service" -w 2>/dev/null)"
fi
if [[ -z "$key" ]]; then
  print -u2 "oxionai-key: keychain 读取失败: $service"
  exit 1
fi
print -r -- "$key"
