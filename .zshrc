bindkey -e                                              # Emacs ライクな操作を有効にする

# =====================================
# 環境変数
# =====================================

export PATH="$GOPATH/bin:$PATH"
export PATH="/usr/local/opt/mysql-client/bin:$PATH"     # MySQL client
export GOPATH=$(go env GOPATH)                          # Go
export LDFLAGS="-L/usr/local/opt/mysql-client/lib"      # For compilers
export CPPFLAGS="-I/usr/local/opt/mysql-client/include" # For compilers

# =====================================
# 履歴
# =====================================
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=1000000

setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# =====================================
# 補完
# =====================================
autoload -Uz compinit && compinit

setopt AUTO_LIST
setopt AUTO_MENU
zstyle ":completion:*:default" menu select=1

eval "$(gh completion -s zsh)"
eval "$(nodenv init -)"
eval "$(starship init zsh)"

source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

alias b="brew"
alias cl="clear"
alias g='git --no-pager'
alias d='docker'
alias dc='docker container'
alias di='docker image'
alias dv="docker volume"
alias d-c="docker compose"
alias m="make"

bindkey '^]' peco-src
function peco-src() {
  local src=$(ghq list --full-path | peco --query "$LBUFFER")
  if [ -n "$src" ]; then
    BUFFER="cd $src"
    zle accept-line
  fi
  zle -R -c
}
zle -N peco-src
