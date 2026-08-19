#!/usr/bin/env bash
set -euo pipefail

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$XDG_CONFIG_HOME/brew"
mkdir -p "$HOME/.claude"
mkdir -p "$XDG_CONFIG_HOME/fish"
mkdir -p "$XDG_CONFIG_HOME/fish/conf.d"
mkdir -p "$XDG_CONFIG_HOME/fish/functions"
mkdir -p "$XDG_CONFIG_HOME/gh"
mkdir -p "$XDG_CONFIG_HOME/git"
mkdir -p "$XDG_CONFIG_HOME/nano"
mkdir -p "$XDG_CONFIG_HOME/npm"
mkdir -p "$XDG_CONFIG_HOME/zsh"

echo "Deploying configuration files..."
config_dir="$(cd "$(dirname "$0")/config" || exit 1 ; pwd)"
ln -fns "$config_dir/brew/.Brewfile"                        "$XDG_CONFIG_HOME/brew"
ln -fns "$config_dir/claude/CLAUDE.md"                      "$HOME/.claude"
ln -fns "$config_dir/claude/settings.json"                  "$HOME/.claude"
ln -fns "$config_dir/fish/conf.d/async_git_status.fish"     "$XDG_CONFIG_HOME/fish/conf.d"
ln -fns "$config_dir/fish/config.fish"                      "$XDG_CONFIG_HOME/fish"
ln -fns "$config_dir/fish/functions/abbr.fish"              "$XDG_CONFIG_HOME/fish/functions"
ln -fns "$config_dir/fish/functions/check_ci_status.fish"   "$XDG_CONFIG_HOME/fish/functions"
ln -fns "$config_dir/fish/functions/fish_prompt.fish"       "$XDG_CONFIG_HOME/fish/functions"
ln -fns "$config_dir/fish/functions/select_history.fish"    "$XDG_CONFIG_HOME/fish/functions"
ln -fns "$config_dir/fish/functions/select_repository.fish" "$XDG_CONFIG_HOME/fish/functions"
ln -fns "$config_dir/gh/config.yml"                         "$XDG_CONFIG_HOME/gh"
ln -fns "$config_dir/git/config"                            "$XDG_CONFIG_HOME/git"
ln -fns "$config_dir/git/ignore"                            "$XDG_CONFIG_HOME/git"
ln -fns "$config_dir/nano/nanorc"                           "$XDG_CONFIG_HOME/nano"
ln -fns "$config_dir/npm/npmrc"                             "$XDG_CONFIG_HOME/npm"

if command -v go >/dev/null 2>&1; then
  echo "Building Go commands..."
  go install "$(dirname "$0")/claude-code-statusline/" "$(dirname "$0")/fish-prompt/" "$(dirname "$0")/fish-prompt-git-status/"
fi
