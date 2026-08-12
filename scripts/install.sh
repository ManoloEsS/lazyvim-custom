#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
nvim_config="$config_home/nvim"
lazyvim_json="$nvim_config/lazyvim.json"

if [[ ! -f "$lazyvim_json" ]]; then
  printf 'Omarchy Neovim config not found: %s\n' "$lazyvim_json" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  printf 'jq is required to merge LazyVim extras.\n' >&2
  exit 1
fi

tmp_file=$(mktemp)
trap 'rm -f "$tmp_file"' EXIT

jq '.extras = ((.extras // []) + [
  "lazyvim.plugins.extras.coding.blink",
  "lazyvim.plugins.extras.editor.snacks_picker",
  "lazyvim.plugins.extras.formatting.prettier",
  "lazyvim.plugins.extras.lang.go",
  "lazyvim.plugins.extras.lang.python",
  "lazyvim.plugins.extras.lang.rust",
  "lazyvim.plugins.extras.lang.typescript",
  "lazyvim.plugins.extras.ui.smear-cursor"
] | unique)' "$lazyvim_json" >"$tmp_file"
mv "$tmp_file" "$lazyvim_json"
trap - EXIT

if ! command -v stow >/dev/null 2>&1; then
  printf 'LazyVim extras enabled. Install GNU Stow, then run:\n'
  printf '  stow -d %q -t %q nvim\n' "$repo_root" "$HOME"
  exit 0
fi

stow -d "$repo_root" -t "$HOME" nvim
printf 'lazyvim-custom overlay installed.\n'
