export ZSH="/Users/awu/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="spaceship"

# load plugins
plugins=(
	git
	vi-mode
	zsh-syntax-highlighting
	zsh-autosuggestions
	autojump
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Codex uses the Metarouter provider without storing its API key in config.toml.
if command -v security >/dev/null 2>&1; then
  export METAROUTER_API_KEY="$(security find-generic-password -a "$USER" -s 'pi/metarouter' -w 2>/dev/null)"
fi
# alias v=nvim
# alias vi=nvim
alias nvm=fnm
alias v=nvim
alias proxy_on="export https_proxy=http://127.0.0.1:7891 http_proxy=http://127.0.0.1:7891 all_proxy=socks5://127.0.0.1:7891"
alias proxy_off="export http_proxy=''; export https_proxy=''; export all_prosy=''"
alias signme="git config --local user.name 'liwuhou' && git config --local user.email 'hugewilliam@foxmail.com'"
alias rr="nr run"
alias rb="nr run build"
alias r="nr run"
alias cc="claude --dangerously-skip-permissions"
# omp 模型组合预设（overlay，不改全局配置；预设文件在 ~/.dotfiles/omp/presets/）
alias omp="omp --config ~/.dotfiles/omp/presets/qwen.yml"
alias ompg="omp --config ~/.dotfiles/omp/presets/gpt.yml"
alias ompk="omp --config ~/.dotfiles/omp/presets/kimi.yml"
alias ompc="omp --config ~/.dotfiles/omp/presets/cheap.yml"


export XIAOE_REGISTRY="http://111.230.199.61:6888/"
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/awu/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# mongodb
export PATH="$HOME/Opt/mongodb/bin:$HOME/Opt/mongosh/bin:$PATH"
# mongodb end

# proxy 
proxy_on

#rs proxy
export RUSTUP_DIST_SERVER="https://rsproxy.cn" 
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

#opencode
export PATH="$HOME/opencode:$PATH"

# fnm init
export PATH="/Users/awu/Library/Application Support/fnm:$PATH"
eval "$(fnm env --use-on-cd)"

# pypnv
export PATH="$(pyenv root)/shims:${PATH}"

# startship
# cargo install startship
eval "$(starship init zsh)"

# init
# brew install bat
if [ "$(command -v bat)" ]; then
	unalias -m 'cat'
	alias cat='bat --theme="Visual Studio Dark+"'
fi
# cargo install exa
if [ "$(command -v exa)" ]; then
	unalias -m 'll'
	unalias -m 'l'
	unalias -m 'la'
	unalias -m 'ls'
	alias ls="exa -G --color auto --icons -a -s type"
	alias ll="exa -l --color always --icons -a -s type"
fi

# welcome
# echo Life is short, play more!
life-progress-cli -b 19941210 -g 1 -n china

# bun completions
[ -s "/Users/awu/.bun/_bun" ] && source "/Users/awu/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by Windsurf
export PATH="/Users/awu/.codeium/windsurf/bin:$PATH"

# Added by Antigravity
export PATH="/Users/awu/.antigravity/antigravity/bin:$PATH"

# opencode
export PATH=/Users/awu/.opencode/bin:$PATH
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# One Dark sets ANSI black (palette 0) == background (#282c34), so the default
# `comment` style (fg=black,bold) renders invisible. That style is also used for
# parameter-elision — a bare `$VAR` whose expansion is empty (e.g. `$ENV` when
# ENV is unset) gets painted with it, so typing `$ENV` at the prompt vanishes.
# Point it at the One Dark gutter grey (#5c6370, the bright-black slot) instead.
ZSH_HIGHLIGHT_STYLES[comment]=fg=#5c6370

[[ -s "/Users/awu/.gvm/scripts/gvm" ]] && source "/Users/awu/.gvm/scripts/gvm"
export ECLI_REGISTRY_URL="https://cli-tool-registry-1252524126.cos.ap-shanghai.myqcloud.com/ecli/registry.yaml"
