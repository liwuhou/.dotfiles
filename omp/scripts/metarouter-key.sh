#!/bin/zsh
# Resolve the active metarouter API key from macOS Keychain.
# Pointer file ~/.omp/metarouter-key holds the Keychain service name;
# switch with `ompkey <name>` (see zshrc). Default: pi/metarouter.
set -u
pointer="$HOME/.omp/metarouter-key"
service="pi/metarouter"
if [[ -r "$pointer" ]]; then
  read -r service < "$pointer"
fi
/usr/bin/security find-generic-password -a "$USER" -s "$service" -w
