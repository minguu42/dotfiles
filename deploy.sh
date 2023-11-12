#!/usr/bin/env bash
set -euo pipefail

XDG_CONFIG_HOME="$HOME/.config"
mkdir -p "$XDG_CONFIG_HOME/brew"
mkdir -p "$XDG_CONFIG_HOME/gh"
mkdir -p "$XDG_CONFIG_HOME/git"
mkdir -p "$XDG_CONFIG_HOME/npm"
mkdir -p "$XDG_CONFIG_HOME/zsh"

CONFIG_HOME="$PWD/.config"
ln -fns "$CONFIG_HOME/brew/.Brewfile"         "$XDG_CONFIG_HOME/brew"
ln -fns "$CONFIG_HOME/gh/config.yml"          "$XDG_CONFIG_HOME/gh"
ln -fns "$CONFIG_HOME/git/config"             "$XDG_CONFIG_HOME/git"
ln -fns "$CONFIG_HOME/git/ignore"             "$XDG_CONFIG_HOME/git"
ln -fns "$CONFIG_HOME/npm/npmrc"              "$XDG_CONFIG_HOME/npm"
ln -fns "$CONFIG_HOME/starship/starship.toml" "$XDG_CONFIG_HOME"
ln -fns "$CONFIG_HOME/zsh/.zshrc"             "$XDG_CONFIG_HOME/zsh"
ln -fns "$PWD/.zshenv"                        "$HOME"
