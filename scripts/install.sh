#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
nvim_config="$config_home/nvim"
lazyvim_json="$nvim_config/lazyvim.json"

if [[ "$nvim_config" != "$HOME/.config/nvim" ]]; then
  printf 'This Stow package targets %s, but Neovim uses %s.\n' "$HOME/.config/nvim" "$nvim_config" >&2
  exit 1
fi

if [[ ! -f "$lazyvim_json" ]]; then
  printf 'Omarchy Neovim config not found: %s\n' "$lazyvim_json" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  printf 'jq is required to merge LazyVim extras.\n' >&2
  exit 1
fi

if ! command -v stow >/dev/null 2>&1; then
  printf 'GNU Stow is required to install the overlay.\n' >&2
  exit 1
fi

if ! jq empty "$lazyvim_json"; then
  printf 'Invalid JSON: %s\n' "$lazyvim_json" >&2
  exit 1
fi

# Detect target conflicts before changing LazyVim's extras.
stow --no --dir "$repo_root" --target "$HOME" nvim

lazyvim_target=$(readlink -f -- "$lazyvim_json")
tmp_file=$(mktemp "$(dirname -- "$lazyvim_target")/.lazyvim.json.XXXXXX")
backup_file=$(mktemp "$(dirname -- "$lazyvim_target")/.lazyvim.json.backup.XXXXXX")
json_replaced=false

cleanup() {
  local status=$?
  trap - EXIT
  rm -f -- "$tmp_file"

  if ((status != 0)) && [[ "$json_replaced" == true ]]; then
    mv -- "$backup_file" "$lazyvim_target"
    printf 'Installation failed; restored %s.\n' "$lazyvim_json" >&2
  else
    rm -f -- "$backup_file"
  fi

  exit "$status"
}
trap cleanup EXIT

cp -p -- "$lazyvim_target" "$backup_file"

jq '.extras = (reduce ((.extras // []) + [
  "lazyvim.plugins.extras.coding.blink",
  "lazyvim.plugins.extras.editor.snacks_picker",
  "lazyvim.plugins.extras.formatting.prettier",
  "lazyvim.plugins.extras.lang.go",
  "lazyvim.plugins.extras.lang.python",
  "lazyvim.plugins.extras.lang.rust",
  "lazyvim.plugins.extras.lang.typescript",
  "lazyvim.plugins.extras.ui.smear-cursor"
] | .[]) as $extra ([]; if index($extra) == null then . + [$extra] else . end))' "$lazyvim_target" >"$tmp_file"
chmod --reference="$lazyvim_target" "$tmp_file"
jq empty "$tmp_file"
mv -- "$tmp_file" "$lazyvim_target"
json_replaced=true

stow --dir "$repo_root" --target "$HOME" nvim
printf 'lazyvim-custom overlay installed.\n'
