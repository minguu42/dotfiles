#!/usr/bin/env bash
set -euo pipefail

if ! xcode-select -p >/dev/null 2>&1 ; then
  echo "Error: xcode-select is not installed."
  echo "Please run 'xcode-select --install' to install the command line tools for xcode."
  exit 1
fi

# ディレクトリがないとうまく動作しないソフトウェアがあるため、XDG Base Directoryのユーザディレクトリを先に作成しておく
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.cache"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/state"

INSTALL_DIR="${INSTALL_DIR:-$HOME/ghq/github.com/minguu42/dotfiles}"

if [[ -d "$INSTALL_DIR" ]] ; then
  echo "Updating dotfiles..."
  git -C "$INSTALL_DIR" pull
else
  echo "Installing dotfiles..."
  git clone https://github.com/minguu42/dotfiles "$INSTALL_DIR"
fi

/bin/bash "$INSTALL_DIR/deploy.sh"

if type brew >/dev/null ; then
  echo "Homebrew is already installed."
else
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Updating Homebrew..."
brew update

echo "Installing dependencies from Homebrew and Homebrew Cask..."
brew bundle install --file "$INSTALL_DIR/config/brew/.Brewfile" --no-lock

fish_path="$(brew --prefix)/bin/fish"
if [[ -f "$fish_path" && "$SHELL" != "$fish_path" ]] ; then
  if ! grep -q "$fish_path" /etc/shells ; then
    echo "Add $fish_path to /etc/shells"
    echo "$fish_path" | sudo tee -a /etc/shells
  fi
  echo "Change login shell to $fish_path"
  chsh -s "$fish_path"
fi
