export ZSH="/Users/awu/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="dracula"

# load plugins
plugins=(
	git
	zsh-nvm
	vi-mode
	zsh-syntax-highlighting
	zsh-autosuggestions
	autojump
)

source $ZSH/oh-my-zsh.sh

# User configuration
alias v=nvim
alias vi=nvim
alias proxy_on="export https_proxy=http://127.0.0.1:7891 http_proxy=http://127.0.0.1:7891 all_proxy=socks5://127.0.0.1:7891"
alias proxy_off="export http_proxy=''; export https_proxy=''; export all_prosy=''"
alias signme="git config --local user.name 'awu' && git config --local user.email 'hugewilliam@foxmail.com'"

# nvm init
export NVM_LAZY_LOAD=true
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion 

autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc
# nvm init end

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
