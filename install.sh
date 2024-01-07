#!/usr/bin/env bash
set -euo pipefail

if type xcode-select >/dev/null ; then
  echo "Command Line Tools for Xcode is already installed."
else
  echo "Installing Command Line Tools for Xcode..."
  xcode-select --install
fi

INSTALL_DIR="${INSTALL_DIR:-$HOME/ghq/github.com/minguu42/dotfiles}"

if [[ -d "$INSTALL_DIR" ]] ; then
  echo "Updating dotfiles..."
  git -C "$INSTALL_DIR" pull
else
  echo "Installing dotfiles..."
  git clone https://github.com/minguu42/dotfiles "$INSTALL_DIR"
fi

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

/bin/bash "$INSTALL_DIR/deploy.sh"

zsh_path="$(brew --prefix)/bin/zsh"
if [[ -f "$zsh_path" && "$SHELL" != "$zsh_path" ]] ; then
  if ! grep -q "$zsh_path" /etc/shells ; then
    echo "Add $zsh_path to /etc/shells"
    echo "$zsh_path" | sudo tee -a /etc/shells
  fi
  echo "Change login shell to $zsh_path"
  chsh -s "$zsh_path"
fi
