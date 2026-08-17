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

## ⚠️ 禁止绝对路径，统一 `$HOME` 相对写法

本仓库跨设备复用，**任何文件里都不允许出现 `/Users/<username>` 形式的绝对路径**（zshrc、plist、models.yml 的 `!command`、脚本等一律用 `$HOME` 或 `~/`）。这些位置都经过 shell 展开，`$HOME` 写法已验证可用（含 LaunchAgent 的 `/bin/sh -c` 和 OMP apiKey 命令）。约定各设备统一把仓库克隆到 `~/.dotfiles`。新增文件时自查；发现存量绝对路径顺手改掉。

## ⚠️ 新文件后运行 `rcup`

rcm 不会自动链接新增文件。添加任意 dotfile（例如 `config/nvim/lua/plugins/example.lua`）后，必须运行 `rcup` 并确认对应的 `~/.config/...` 链接已创建；否则使用方无法看到新配置。

rcm 对 `~/.config/*` 链接单个文件而不是整个目录。`~/.config/nvim` 是实际目录，内部文件分别链接回 `~/.dotfiles/config/nvim/`；新增嵌套文件后同样需要运行 `rcup`。

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

## Neovim（LazyVim）

Neovim 配置位于 `config/nvim/`，通过 `rcup` 链接到 `~/.config/nvim`；使用 `nvim`（或 `v`）启动。自定义选项、键位和自动命令分别在 `lua/config/`，插件配置在 `lua/plugins/editor.lua`。

`config/nvim/lazy-lock.json` 是受版本控制的插件锁文件。更新插件后运行 `:Lazy sync` 并提交它。Neovim 0.12 使用的 `nvim-treesitter` 必须固定在 `main` 分支，避免旧 `master` 生成的 parser ABI 不兼容。

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

