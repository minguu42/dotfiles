if [ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]
then
   ZSH_TMUX_AUTOSTART=true
fi

export GOPATH=$(go env GOPATH)                          # Go
export PATH="$GOPATH/bin:$PATH"
export PATH="/usr/local/opt/mysql-client/bin:$PATH"     # MySQL client
export LDFLAGS="-L/usr/local/opt/mysql-client/lib"      # For compilers
export CPPFLAGS="-I/usr/local/opt/mysql-client/include" # For compilers

eval "$(gh completion -s zsh)"
eval "$(nodenv init -)"
eval "$(starship init zsh)"

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
