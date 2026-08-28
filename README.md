# lazyvim-custom

Small, stow-ready preferences layered on top of Omarchy's base LazyVim configuration.

This package intentionally adds plugin specs under `lua/plugins/` instead of replacing Omarchy's `lua/config/options.lua`, `keymaps.lua`, or `autocmds.lua`. Those files already exist in a fresh installation, and replacing them would discard Omarchy defaults.

## Fresh Omarchy Installation

After Omarchy has created its Neovim configuration, clone this repository into `~/lazyvim-custom` and run the installer:

```sh
git clone https://github.com/ManoloEsS/lazyvim-custom.git ~/lazyvim-custom
bash ~/lazyvim-custom/scripts/install.sh
```

The installer adds the LazyVim extras to the existing `lazyvim.json` before
stowing the custom plugin files. This preserves LazyVim's required import
order: base plugins, LazyVim extras, then custom plugins.

The resulting overlay files are:

```text
~/.config/nvim/plugin/after/transparency.lua
~/.config/nvim/lua/plugins/lazyvim-custom.lua
~/.config/nvim/lua/plugins/hide-bufferline.lua
~/.config/nvim/lua/plugins/marks.lua
~/.config/nvim/lua/plugins/blink.lua
~/.config/nvim/lua/plugins/harpoon.lua
~/.config/nvim/lua/plugins/language-formatting.lua
~/.config/nvim/lua/plugins/yazi.lua
~/.config/nvim/lua/plugins/orgmode.lua
~/.config/nvim/lua/plugins/smear-cursor.lua
```

Start Neovim and run `:Lazy sync` if prompted. The overlay does not replace `init.lua`, `lazy.lua`, `lazyvim.json`, or `lazy-lock.json`.

## Theme Transparency

`nvim/.config/nvim/plugin/after/transparency.lua` removes only the background
attribute from Neovim UI highlight groups while preserving their foreground
colors and styles. It covers completion menus, floating documentation, and
other popup groups so they match the transparent editor background across
themes.

The `LspInlayHint` group is included specifically for language-server inlay
hints. For example, Rust Analyzer can render an inferred type such as `:i32`
between `let x` and `= 1`. Tokyo Night and some other themes give that hint a
colored background, which creates an unwanted block behind the inline text.
Removing only its background keeps the hint readable without changing the
theme's hint color.

This belongs in the custom overlay rather than an Omarchy stock theme because
`/usr/share/omarchy/themes/` is package-managed and changes there would be
lost during updates. The Stow package also deploys the same fix on other
systems. If Neovim is already open after installing or updating the overlay,
reload it with:

```vim
:source ~/.config/nvim/plugin/after/transparency.lua
:redraw!
```

Yazi itself is a system application rather than a Mason tool. Install it separately:

```sh
sudo pacman -S yazi
```

## Included Preferences

- Four-space indentation.
- Relative line numbers (`relativenumber = true`).
- Fast recognition of standalone Esc with a 20ms terminal timeout.
- Omarchy's automatic formatting behavior preserved (`vim.g.autoformat = false`).
- Transparent completion, inlay-hint, and floating popup backgrounds across themes.
- Hidden tabline/bufferline display via `showtabline = 0`.
- Snacks picker extra for undo history and mark browsing.
- `marks.nvim` for mark management.
- Blink completion with Tab and Shift-Tab mappings disabled.
- Harpoon2 file marks under the `<leader>m` namespace.
- Yazi file manager on `\\`; Neo-tree remains on `<leader>e`.
- Orgmode and org-bullets with the Kickstart capture template; no Org LSP or Telescope integration.
- Smear Cursor through LazyVim's UI extra with the Kickstart animation preferences.
- Mason-managed language extras for Python, TypeScript/JavaScript, Go, and Rust.
- Buffer-local format-on-save for those languages, plus organize-imports before formatting where the attached LSP supports it.
- `.gotmpl` filetype detection.
- Selected Kickstart editing mappings and argument-list replacement helpers.
- Existing Omarchy ownership of Neo-tree, Snacks, completion, LSP, Treesitter, themes, and formatters is preserved.

To undo the overlay:

```sh
stow -d ~/lazyvim-custom -t ~ -D nvim
```

Then use `:LazyExtras` to disable the eight extras listed in
`scripts/install.sh` and run `:Lazy sync`. Unstowing removes the custom plugin
specs but intentionally does not rewrite `lazyvim.json`.
