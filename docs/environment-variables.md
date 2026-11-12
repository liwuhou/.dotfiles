# 环境变量

本仓库由 rcm 链接到 `$HOME`。下面按来源列出实际被设置或读取的变量；命令以本机当前文件为准。

## zsh 启动时导出

| 变量 | 值 / 用途 |
|---|---|
| `ZSH` | `$HOME/.oh-my-zsh` |
| `METAROUTER_API_KEY` | 终端内 Codex 使用；由 `omp/scripts/metarouter-key.sh` 解析后导出 |
| `XIAOE_REGISTRY` | `http://111.230.199.61:6888/` |
| `PNPM_HOME` | `$HOME/Library/pnpm`，其 `bin` 会加入 `PATH` |
| `RUSTUP_DIST_SERVER` | `https://rsproxy.cn` |
| `RUSTUP_UPDATE_ROOT` | `https://rsproxy.cn/rustup` |
| `PYENV_ROOT` | 默认 `$HOME/.pyenv`，已存在时保留外部值 |
| `BUN_INSTALL` | `$HOME/.bun` |
| `ECLI_REGISTRY_URL` | ECLI 工具 registry 地址 |
| `http_proxy` / `https_proxy` / `all_proxy` | 登录 shell 启动时由 `proxy_on` 设置，见下文 |

`bashrc` 另外设置 `NVM_DIR="$HOME/.nvm"`，并 source `nvm.sh`、`bash_completion` 与 `$HOME/.cargo/env`。

## PATH

zsh 中按导出的逆序生效，最终从前往后为：

1. `$HOME/.opencode/bin`
2. `$HOME/.antigravity/antigravity/bin`
3. `$HOME/.codeium/windsurf/bin`
4. `$BUN_INSTALL/bin`
5. `$PYENV_ROOT/shims`
6. `$HOME/Library/Application Support/fnm`
7. `$HOME/opencode`
8. `$HOME/Opt/mongodb/bin`
9. `$HOME/Opt/mongosh/bin`
10. `$PNPM_HOME/bin`
11. `$HOME/.local/bin`
12. 继承的系统 `PATH`

bash 只额外前置 `$HOME/.local/bin`，随后由 `$HOME/.cargo/env` 加入 Cargo 的 `bin`。

## 代理

`zshrc` 在每个新 shell 中直接执行 `proxy_on`，因此默认已开启：

```sh
http_proxy=http://127.0.0.1:7891
https_proxy=http://127.0.0.1:7891
all_proxy=socks5://127.0.0.1:7891
```

`proxy_off` 会清空 `http_proxy`、`https_proxy`，但脚本里把变量名拼成了 `all_prosy`，所以 `all_proxy` 实际不会被清空；需要彻底关闭时手动执行 `unset all_proxy`。

## OMP / Codex 密钥

密钥不落仓库，统一由 `omp/scripts/metarouter-key.sh` 解析：

1. 指针文件 `~/.omp/metarouter-key` 指定 Keychain service（默认 `pi/metarouter`）。
2. 从 macOS Keychain 读取；失败时回退到 `~/.omp/metarouter-key-value`（0600，第一行 service，第二行 key）。
3. `ompkey <name>` 切换 service：先校验、再写指针，并同步兜底文件。

消费方：

- `omp/agent/models.yml` 的 `apiKey` 使用 `!"$HOME"/.dotfiles/omp/scripts/metarouter-key.sh`。
- `zshrc` 把它导出为 `METAROUTER_API_KEY`，供终端内的 Codex CLI 使用。
- `claude/scripts/codex-environment.plist` 是 LaunchAgent `com.awu.codex-environment`，启动时执行同一脚本并 `launchctl setenv METAROUTER_API_KEY`，供 GUI 应用使用。用 `claude/scripts/install-codex-environment.sh` 安装或刷新。

注意：

- `launchctl setenv` 只影响之后启动的进程；已在运行的 Codex/GUI 应用需重启。
- 脚本刻意不依赖 `$USER`（launchd 环境可能没有该变量），改用 `id -un`。
- `security` 通过 `$HOME` 定位 keychain，覆盖 `HOME` 会导致读取失败。
- `pi/agent/models.json` 仍使用 `$USER` 和 `security find-generic-password`，属于旧 pi 配置；当前 OMP 行为以 `omp/agent/` 为准。

## Raycast AI

`~/.config/raycast/ai/providers.yaml` 由 rcm 链接到 `config/raycast/ai/providers.yaml`，配置 `metarouter-primary`，其 `base_url` 指向本机代理 `http://127.0.0.1:8787/v1`。Raycast 原生 provider 配置不支持从 Keychain 读取密钥，因此由本地代理处理上游认证。

代理只从 macOS Keychain 的 `pi/metarouter` service 读取密钥，不使用 OMP 脚本的明文 fallback；Raycast 配置不保存密钥，可正常提交 Git。代理脚本位于 `raycast/scripts/`，由 `rcrc` 排除；providers 配置仍由 rcm 管理。用 `raycast/scripts/install-metarouter-proxy.sh` 安装 LaunchAgent `com.awu.raycast-metarouter`，登录后 launchd 启动代理。更新 Node 安装位置后需重新运行安装脚本；手动重启：

```sh
launchctl kickstart -k "gui/$(id -u)/com.awu.raycast-metarouter"
```

每次请求都会重新读取 Keychain；锁定或密钥不可读时返回 HTTP 503，解锁或轮换密钥后下一次请求自动生效，无需重启。

## 其他配置读取的变量

| 变量 | 读取方 | 说明 |
|---|---|---|
| `TERM_PROGRAM` | `tmux.conf` | 非 Apple Terminal 时启用 RGB |
| `MYVIMRC` | `vimrc` | Vim 自动设置，保存后重新 source |
| `UID` | `skhdrc` | 重启 yabai 的 LaunchAgent |
| `HOME` | `yabairc`、`metarouter-key.sh`、OMP `apiKey` | 所有路径统一用 `$HOME` / `~/` |

## 排查

```sh
printenv | sort                 # 当前环境
echo "$PATH" | tr ':' '\n'      # 检查路径顺序
launchctl getenv METAROUTER_API_KEY
~/.dotfiles/omp/scripts/metarouter-key.sh | wc -c   # 非 0 即可读到 key
```

仓库约定：任何配置里都不允许出现 `/Users/<username>` 形式的绝对路径，统一使用 `$HOME` 或 `~/`。新增文件后运行 `rcup` 使其链接到 `$HOME`。
