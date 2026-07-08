# Dotfiles — Working Notes

This repo is managed with **rcm** (brew). Config source of truth lives here;
`~/.config/<tool>` and other dotfiles are **file-level symlinks** back into
this repo, created/updated by `rcup`.

## rcm workflow

| Task | Command |
|---|---|
| Apply all dotfiles (create symlinks) | `rcup` |
| See what rcm manages | `lsrc` |
| Adopt an existing `~/.config/x/y` into the repo | `mkrc ~/.config/x/y` |
| Config (excludes, etc.) | `~/.dotfiles/rcrc` |

`rcrc` currently sets `EXCLUDES="README.md CLAUDE.md package.json node_modules claude"`.

## ⚠️ Critical lesson: run `rcup` after adding NEW files

**rcm does not auto-link new files.** When you add a new file or subdirectory
to this repo (e.g. `config/lvim/queries/regex/highlights.scm`), the symlink
into `~/.config/...` is **not** created until you run `rcup`. A new file that
sits only in the repo is invisible to the consuming tool — configs silently
fail to take effect.

This bit us with the LunarVim regex query override: the file was committed
to `config/lvim/queries/regex/highlights.scm` but `rcup` was never run, so
nvim never saw it and the "Invalid node type <" treesitter error persisted
across what looked like a "fixed" commit. The symlink only appeared after an
explicit `rcup`.

**Rule:** after creating/adding any new dotfile in this repo, run `rcup` and
verify the symlink landed (e.g. `ls -l ~/.config/<tool>/<path>`). Do not
assume a committed file is live.

## Symlink granularity

rcm links **individual files**, not whole directories (for `~/.config/*`
targets). `~/.config/lvim` is a real directory; its contents
(`config.lua`, `lazy-lock.json`, `lua/...`, `queries/...`) are each symlinks
into `~/.dotfiles/config/lvim/`. So adding a new nested file requires `rcup`
to link that specific path — copying into a real subdir under `~/.config`
would drift from the repo.

## OMP

Active `omp` user config lives under `~/.omp/agent` (`omp config path`). This
repo now tracks the live source files at `omp/agent/config.yml` and
`omp/agent/models.yml`, linked by rcm to `~/.omp/agent/config.yml` and
`~/.omp/agent/models.yml`.

Use `omp config get <key>` / `omp config list` to inspect effective settings;
`omp config set/reset` writes to the live global config file. If either
`config.yml` or `models.yml` is newly adopted or recreated, run `rcup` and
verify the symlinks:

```sh
ls -l ~/.omp/agent/config.yml ~/.omp/agent/models.yml
```

Do not manage OMP through the legacy `~/.pi/agent` files for current `omp`
behavior. LSP is enabled by schema defaults unless overridden in
`omp/agent/config.yml`; project-specific LSP overrides belong in
`<repo>/.omp/lsp.json` or another documented OMP LSP config path, not in the
global model config.

## LunarVim (self-maintained fork)

LunarVim upstream is abandoned at `release-1.4/neovim-0.9`. The local install
at `~/.local/share/lunarvim/lvim` points `origin` at our fork
`liwuhou/LunarVim` (branch `release-1.4/neovim-0.12`); `upstream` is the
official repo. Compat fixes (telescope master for the Find File refilter bug,
treesitter main for nvim 0.12 ABI) live as commits on the fork's snapshot
file (`snapshots/default.json`) — LunarVim forces core-plugin commits from
that snapshot on every launch (`plugins.lua:377-382`), so the lockfile in
`config/lvim/lazy-lock.json` is informational, not authoritative.

User config in `config/lvim/` consumes the framework and stays mostly
fork-agnostic. The `basic.lua` nvim-0.12 workarounds (indentlines/illuminate
guards, treesitter runtime injection, FileType highlight autocmd, log.level)
are kept because LunarVim core still assumes the old treesitter API.

## Karabiner-Elements

`~/.config/karabiner/karabiner.json` is an rcm symlink into
`config/karabiner/karabiner.json`. Edits to the source file are picked up by
Karabiner's file watcher — but see the reload caveat below.

**Reload caveat (DriverKit architecture):** this Karabiner build uses
DriverKit (`Karabiner-Core-Service` + `org.pqrs.Karabiner-DriverKit-VirtualHIDDevice`
dext), NOT the legacy `karabiner_grabber` process. So `karabiner_grabber` not
running is normal here. `karabiner_cli reload` (at
`/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli`)
returns exit 0 but **does not always re-apply the config to the running
Core-Service** — a rule change can sit in the file, valid and reloaded, yet
still trigger the old behavior. When a confirmed-correct edit doesn't take
effect after `reload`, restart Karabiner (quit & reopen the app, or
`sudo killall Karabiner-Core-Service karabiner_console_user_server` and relaunch)
to force the running state to re-read the config. Don't waste time
re-checking the file/symlink in that situation — verify the file is correct
once, then go straight to a service restart.

Config shape: one profile ("Default"), no global simple_modifications, 10
complex-modification rule groups organized around a Hyper key
(CapsLock → right_command+right_control+right_shift+right_option), plus
per-device simple_modifications for ~15 keyboards. App launchers live in the
"Hyper Application" group as `shell_command: open -a <App>`.

