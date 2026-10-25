#!/usr/bin/env bash
# Link the dotfiles into $HOME (or the directory given as $1).
set -euo pipefail

target="${1:-$HOME}"
cd "$(dirname "$0")"

# Real directories, so stow links each app's folder inside them instead of
# linking ~/.config or ~/.pi wholesale (apps would then write into this repo).
mkdir -p "$target/.config" "$target/.pi/agent"

stow --dotfiles --restow --target "$target" .
