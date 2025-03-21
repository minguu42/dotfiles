### 環境変数
eval "$(/opt/homebrew/bin/brew shellenv)"

set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME  "$HOME/.cache"
set -gx XDG_DATA_HOME   "$HOME/.local/share"
set -gx XDG_STATE_HOME  "$HOME/.local/state"

set -gx GOPATH               "$XDG_DATA_HOME/go"
set -gx HOMEBREW_BUNDLE_FILE "$XDG_CONFIG_HOME/brew/.Brewfile"

### エイリアス
alias grep ggrep
alias sed  gsed

### 略語
abbr -a b brew
abbr -a d docker
abbr -ac docker c container
abbr -ac docker i image
abbr -ac docker p compose
abbr -ac docker m compose
abbr -ac docker n network
abbr -ac docker v volume
abbr -a g git
abbr -ac git ad add
abbr -ac git br branch
abbr -ac git cm commit
abbr -ac git df diff
abbr -ac git lg log -n 15
abbr -ac git mg merge
abbr -ac git ph push
abbr -ac git pl pull --prune
abbr -ac git rs reset
abbr -ac git rt remote
abbr -ac git rv revert
abbr -ac git sm submodule
abbr -ac git ss stash
abbr -ac git st status
abbr -ac git sw switch
abbr -ac gh prc pr create
abbr -ac gh prm pr merge
abbr -ac gh prw pr checks -i 5 --watch
abbr -ac gh prv pr view
abbr -a m make

### キーバインド
bind ctrl-g select_repository
bind ctrl-r select_history

### 設定
set -g fish_greeting # welcomeメッセージを表示しない

### プラグイン
direnv hook fish | source
starship init fish | source
