export ZSH="/Users/awu/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="spaceship"

# load plugins
plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
	autojump
)

source $ZSH/oh-my-zsh.sh

# User configuration
# alias v=nvim
# alias vi=nvim
alias v="$HOME/.local/bin/lvim"
alias vi="$HOME/.local/bin/lvim"
alias proxy_on="export https_proxy=http://127.0.0.1:7891 http_proxy=http://127.0.0.1:7891 all_proxy=socks5://127.0.0.1:7891"
alias proxy_off="export http_proxy=''; export https_proxy=''; export all_prosy=''"
alias signme="git config --local user.name 'awu' && git config --local user.email 'hugewilliam@foxmail.com'"

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
eval "`fnm env --use-on-cd`"

# welcome
echo Life is short, play more!
