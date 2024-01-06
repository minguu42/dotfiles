#!/usr/bin/env bash
set -euo pipefail

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$XDG_CONFIG_HOME/brew"
mkdir -p "$XDG_CONFIG_HOME/gh"
mkdir -p "$XDG_CONFIG_HOME/git"
mkdir -p "$XDG_CONFIG_HOME/npm"
mkdir -p "$XDG_CONFIG_HOME/zsh"

echo "Deploying configuration files..."
config_dir="$(cd "$(dirname "$0")/config" || exit 1 ; pwd)"
ln -fns "$config_dir/brew/.Brewfile"         "$XDG_CONFIG_HOME/brew"
ln -fns "$config_dir/gh/config.yml"          "$XDG_CONFIG_HOME/gh"
ln -fns "$config_dir/git/config"             "$XDG_CONFIG_HOME/git"
ln -fns "$config_dir/git/ignore"             "$XDG_CONFIG_HOME/git"
ln -fns "$config_dir/npm/npmrc"              "$XDG_CONFIG_HOME/npm"
ln -fns "$config_dir/starship/starship.toml" "$XDG_CONFIG_HOME"
ln -fns "$config_dir/zsh/.zshenv"            "$HOME"
ln -fns "$config_dir/zsh/.zshrc"             "$XDG_CONFIG_HOME/zsh"
