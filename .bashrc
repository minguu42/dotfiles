# エイリアス
alias b="brew"
alias cl="clear"
alias g="git"
alias d="docker"
alias dc="docker container"
alias dm="docker compose"
alias di="docker image"
alias dv="docker volume"
alias m="make"

peco-history() {
    declare l=$(HISTTIMEFORMAT=  history | LC_ALL=C sort -r |  awk '{for(i=2;i<NF;i++){printf("%s%s",$i,OFS=" ")}print $NF}'   |  peco --query "$READLINE_LINE")
    READLINE_LINE="$l"
    READLINE_POINT=${#l}
}
bind -x '"\C-r": peco-history'

peco-src() {
  local repo=$(ghq list | peco --query "$LBUFFER")
  if [ -n "$repo" ]; then
    repo=$(ghq list --full-path --exact $repo)
    READLINE_LINE="cd $repo"
    READLINE_POINT=${#READLINE_LINE}
  fi
}
bind -x '"\C-g": peco-src'

eval "$(starship init bash)"
