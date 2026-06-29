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

`rcrc` currently sets `EXCLUDES="README.md package.json node_modules claude"`.

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
