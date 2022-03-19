#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [[ ! -d "$HOME/.config" ]]; then
  mkdir "$HOME/.config"
fi

if [[ ! -d "$HOME/.config/brew" ]]; then
  mkdir "$HOME/.config/brew"
fi

if [[ ! -d "$HOME/.config/gh" ]]; then
  mkdir "$HOME/.config/gh"
fi

if [[ ! -d "$HOME/.config/git" ]]; then
  mkdir "$HOME/.config/git"
fi

for fd1 in .??*; do
  [[ "$fd1" == ".git" ]] && continue
  [[ "$fd1" == ".gitignore" ]] && continue
  [[ "$fd1" == ".idea" ]] && continue

  if [[ "$fd1" == ".config" ]]; then
    while read -r f2; do
      if [[ ! -d "$f2" ]]; then
        ln -fns "$PWD/$f2" "$HOME/$(dirname "$f2")"
      fi
    done < <(find .config -mindepth 1 -maxdepth 2)
  fi
  if [[ "$fd1" != ".config" ]]; then
    ln -fns "$PWD/$fd1" "$HOME"
  fi
done
