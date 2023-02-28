set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_CACHE_HOME "$HOME/.cache"
set -x XDG_DATA_HOME "$HOME/.local/share"
set -x XDG_STATE_HOME "$HOME/.local/state"

set -x GOPATH "$XDG_DATA_HOME/go"
set -x HOMEBREW_BUNDLE_FILE "$XDG_CONFIG_HOME/brew/.Brewfile"
set -x NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
set -x VOLTA_HOME "$XDG_DATA_HOME/volta"

# PATHを通す
set -x PATH "$GOPATH/bin" $PATH
set -x PATH "$VOLTA_HOME/bin" $PATH

alias b "brew"
alias g "git"
alias d "docker"
alias m "make"
alias n "npm run"

starship init fish | source
