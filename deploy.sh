#!/usr/bin/env bash
set -euo pipefail

XDG_CONFIG_HOME="$HOME/.config"
mkdir -p "$XDG_CONFIG_HOME/brew"
mkdir -p "$XDG_CONFIG_HOME/gh"
mkdir -p "$XDG_CONFIG_HOME/git"
mkdir -p "$XDG_CONFIG_HOME/npm"
mkdir -p "$XDG_CONFIG_HOME/zsh"

CONFIG_DIR="$(cd "$(dirname "$0")/config" || exit 1; pwd)"
ln -fns "$CONFIG_DIR/brew/.Brewfile"         "$XDG_CONFIG_HOME/brew"
ln -fns "$CONFIG_DIR/gh/config.yml"          "$XDG_CONFIG_HOME/gh"
ln -fns "$CONFIG_DIR/git/config"             "$XDG_CONFIG_HOME/git"
ln -fns "$CONFIG_DIR/git/ignore"             "$XDG_CONFIG_HOME/git"
ln -fns "$CONFIG_DIR/npm/npmrc"              "$XDG_CONFIG_HOME/npm"
ln -fns "$CONFIG_DIR/starship/starship.toml" "$XDG_CONFIG_HOME"
ln -fns "$CONFIG_DIR/zsh/.zshenv"            "$HOME"
ln -fns "$CONFIG_DIR/zsh/.zshrc"             "$XDG_CONFIG_HOME/zsh"
