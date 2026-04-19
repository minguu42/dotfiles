### 環境変数
eval "$(/opt/homebrew/bin/brew shellenv)"

set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME  "$HOME/.cache"
set -gx XDG_DATA_HOME   "$HOME/.local/share"
set -gx XDG_STATE_HOME  "$HOME/.local/state"

set -gx GOPATH                         "$XDG_DATA_HOME/go"
set -gx HOMEBREW_BUNDLE_DUMP_NO_GO     "true"
set -gx HOMEBREW_BUNDLE_DUMP_NO_VSCODE "true"
set -gx HOMEBREW_BUNDLE_FILE           "$XDG_CONFIG_HOME/brew/.Brewfile"
set -gx NPM_CONFIG_USERCONFIG          "$XDG_CONFIG_HOME/npm/npmrc"

if test -d "$HOME/.local/bin"; fish_add_path -Pm "$HOME/.local/bin"; end
if test -d "$XDG_DATA_HOME/go/bin"; fish_add_path -Pm "$XDG_DATA_HOME/go/bin"; end

### エイリアス
alias grep ggrep
alias sed  gsed

### 略語
abbr -a b brew
abbr -a c claude
abbr -a d docker
abbr_subcommand docker c container
abbr_subcommand docker i image
abbr_subcommand docker m compose
abbr_subcommand docker n network
abbr_subcommand docker v volume
abbr -a g git
abbr_subcommand git ad add
abbr_subcommand git br branch
abbr_subcommand git cm commit
abbr_subcommand git co checkout
abbr_subcommand git df diff
abbr_subcommand git lg log -n 15
abbr_subcommand git mg merge
abbr_subcommand git ph push
abbr_subcommand git pl pull --prune
abbr_subcommand git rb rebase
abbr_subcommand git rs reset
abbr_subcommand git rt restore
abbr_subcommand git rv revert
abbr_subcommand git sm submodule
abbr_subcommand git ss stash
abbr_subcommand git st status
abbr_subcommand git sw switch
abbr_subcommand git wt worktree
abbr_subsubcommand gh pr c create
abbr_subsubcommand gh pr co checkout
abbr_subsubcommand gh pr m merge
abbr_subsubcommand gh pr w checks -i 5 --watch
abbr_subsubcommand gh pr v view
abbr -a m make
abbr -a pn pnpm
abbr -a tf terraform

### キーバインド
bind ctrl-g select_repository
bind ctrl-r select_history

### 設定
set -g fish_greeting # welcomeメッセージを表示しない

### プラグイン
direnv hook fish | source
starship init fish | source
