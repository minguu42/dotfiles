### Homebrewで使用する環境変数を設定する
eval "$(/opt/homebrew/bin/brew shellenv)"

### 環境変数
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export GOPATH="$XDG_DATA_HOME/go"
export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/brew/.Brewfile"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NVM_DIR="$XDG_DATA_HOME/nvm"

export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$XDG_DATA_HOME/npm/bin"

### エイリアス
alias b="brew"
alias d="docker"
alias dc="docker container"
alias di="docker image"
alias dm="docker compose"
alias dn="docker network"
alias dv="docker volume"
alias g="git"
alias grep="ggrep"
alias m="make"
alias n="npm run"
alias sed="gsed"

### キーバインド
bindkey '^g' select-repository
function select-repository() {
  local src=$(ghq list --full-path | peco --query "$LBUFFER")
  if [ -n "$src" ]; then
    BUFFER="cd $src"
    zle accept-line
  fi
  zle -R -c
}
zle -N select-repository

bindkey '^r' select-history
funciton select-history() {
  BUFFER=`history -n 1 | tail -r | awk '!seen[\$0]++' | peco --query "$LBUFFER"`
  CURSOR=$#BUFFER
  zle -R -c
}
zle -N select-history

### 履歴
export HISTFILE="$XDG_STATE_HOME/zsh_history" # 履歴を保存するファイル
export HISTSIZE=100000                        # メモリ上に保存する履歴のサイズ
export SAVEHIST=1000000                       # 上述のファイルに保存する履歴のサイズ

setopt inc_append_history # 実行時に履歴をファイルに追加していく
setopt share_history      # 履歴を他のシェルとリアルタイム共有する

### 補完
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh-completions:$FPATH"

  # 補完の有効化
  autoload -Uz compinit
  compinit
fi

# 補完候補をそのまま探す -> 小文字を大文字に変えて探す -> 大文字を小文字に変えて探す
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}'
# 補完方法毎にグループ化する
zstyle ':completion:*' format '%B%F{blue}%d%f%b'
zstyle ':completion:*' group-name ''
# 補完候補を一覧から選択する。補完候補が2つ以上なければすぐに補完する
zstyle ':completion:*:default' menu select=2

### その他の設定
setopt auto_cd         # ディレクトリ名を入力した際に自動的にディレクトリを変更する
setopt no_flow_control # ^S、^Qによるフローコントロールを無効化する

[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh" # nvmをロードする
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node_history"

### プラグイン
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

eval "$(direnv hook zsh)"

### プロンプト
eval "$(starship init zsh)"
