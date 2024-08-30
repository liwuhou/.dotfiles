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
# alias v=nvim
# alias vi=nvim
alias nvm=fnm
alias v="$HOME/.local/bin/lvim"
alias proxy_on="export https_proxy=http://127.0.0.1:7891 http_proxy=http://127.0.0.1:7891 all_proxy=socks5://127.0.0.1:7891"
alias proxy_off="export http_proxy=''; export https_proxy=''; export all_prosy=''"
alias signme="git config --local user.name 'liwuhou' && git config --local user.email 'hugewilliam@foxmail.com'"
alias rr="nr run"
alias rb="nr run build"
alias r="nr run"

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

# fnm init
export PATH="/Users/awu/Library/Application Support/fnm:$PATH"
eval "$(fnm env --use-on-cd)"

# startship
eval "$(starship init zsh)"

# init
if [ "$(command -v bat)" ]; then
	unalias -m 'cat'
	alias cat='bat --theme="Visual Studio Dark+"'
fi
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
