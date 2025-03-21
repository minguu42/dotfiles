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
abbr -a m make

### キーバインド
bind ctrl-g select_repository
bind ctrl-r select_history

### 設定
set -g fish_greeting # welcomeメッセージを表示しない

### プラグイン
direnv hook fish | source
starship init fish | source
