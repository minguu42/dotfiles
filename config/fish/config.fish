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
if test -d "$HOMEBREW_PREFIX/opt/node@24/bin"; fish_add_path -Pm "$HOMEBREW_PREFIX/opt/node@24/bin"; end
if test -d "$XDG_DATA_HOME/go/bin"; fish_add_path -Pm "$XDG_DATA_HOME/go/bin"; end
if test -d "$XDG_DATA_HOME/npm/bin"; fish_add_path -Pm "$XDG_DATA_HOME/npm/bin"; end

### エイリアス
alias grep ggrep
alias sed  gsed

### 略語
abbr -a b brew
abbr -a c claude
abbr -a d docker
abbr -a d_c --regex c --command docker container
abbr -a d_i --regex i --command docker image
abbr -a d_m --regex m --command docker compose
abbr -a d_n --regex n --command docker network
abbr -a d_v --regex v --command docker volume
abbr -a g git
abbr -a g_ad  --regex ad --command git add
abbr -a g_br  --regex br --command git branch
abbr -a g_cm  --regex cm --command git commit
abbr -a g_co  --regex co --command git checkout
abbr -a g_df  --regex df --command git diff
abbr -a g_lg  --regex lg --command git log -n 15
abbr -a g_mg  --regex mg --command git merge
abbr -a g_ph  --regex ph --command git push
abbr -a g_pl  --regex pl --command git pull --prune
abbr -a g_rb  --regex rb --command git rebase
abbr -a g_rs  --regex rs --command git reset
abbr -a g_rr  --regex rt --command git restore
abbr -a g_rv  --regex rv --command git revert
abbr -a g_sm  --regex sm --command git submodule
abbr -a g_ss  --regex ss --command git stash
abbr -a g_st  --regex st --command git status
abbr -a g_sw  --regex sw --command git switch
abbr -a gh_c  --regex c  --command gh create
abbr -a gh_co --regex co --command gh checkout
abbr -a gh_m  --regex m  --command gh merge
abbr -a gh_w  --regex w  --command gh checks -i 5 --watch
abbr -a gh_v  --regex v  --command gh view
abbr -a m make

### キーバインド
bind ctrl-g select_repository
bind ctrl-r select_history

### 設定
set -g fish_greeting # welcomeメッセージを表示しない

### プラグイン
direnv hook fish | source
starship init fish | source
