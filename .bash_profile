export GOPATH=$(go env GOPATH)
export PATH="$GOPATH/bin/:$PATH"
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/mysql-client/lib"
export CPPFLAGS="-I/usr/local/opt/mysql-client/include"
export HOMEBREW_BUNDLE_FILE="$HOME/.config/brew/.Brewfile"

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
eval "$(gh completion -s bash)"
eval "$(nodenv init -)"

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
