---
name: lazyvim-custom
description: Use when installing or maintaining the lazyvim-custom stow overlay on a fresh Omarchy installation, especially when adding Kickstart.nvim preferences without replacing the base LazyVim configuration.
---

# lazyvim-custom Overlay

Use this skill when working with the `lazyvim-custom` repository or when the user asks to apply the Kickstart-derived Neovim preferences to Omarchy LazyVim.

## Core Rule

Preserve Omarchy's base LazyVim configuration. Do not replace or adopt these files:

- `~/.config/nvim/init.lua`
- `~/.config/nvim/lua/config/lazy.lua`
- `~/.config/nvim/lua/config/options.lua`
- `~/.config/nvim/lua/config/keymaps.lua`
- `~/.config/nvim/lua/config/autocmds.lua`
- `~/.config/nvim/lazyvim.json`
- `~/.config/nvim/lazy-lock.json`

The stow package should add only new plugin files, while the installer may
make a surgical merge into the existing `lazyvim.json` extras array:

```text
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

LazyVim extras must be listed in `~/.config/nvim/lazyvim.json`, before the
custom `plugins` import. Do not import `lazyvim.plugins.extras.*` from files
under `lua/plugins/`, because that produces LazyVim's import-order warning.

This avoids stow conflicts with regular files already created by Omarchy.

## Fresh Installation

After Omarchy has created its Neovim configuration:

```sh
git clone https://github.com/ManoloEsS/lazyvim-custom.git ~/lazyvim-custom
bash ~/lazyvim-custom/scripts/install.sh
```

The installer merges Blink, Snacks picker, Prettier, Go, Python, Rust,
TypeScript, and Smear Cursor extras into the existing `lazyvim.json`, then
runs Stow for the new plugin files.

Never use `stow --adopt` for this overlay. Adoption would move Omarchy's base files into the custom repository and undermine the layered setup. Never replace the entire `lazyvim.json`; merge only the requested extras.

To remove the overlay:

```sh
stow -d ~/lazyvim-custom -t ~ -D nvim
```

Then disable the overlay's eight extras with `:LazyExtras` and run
`:Lazy sync`. Unstowing does not remove entries from `lazyvim.json`.

## Change Guidelines

- Extend existing LazyVim plugin specs instead of calling plugin setup functions directly.
- Preserve Neo-tree as the file explorer.
- Preserve LazyVim's LSP, completion, Treesitter, Snacks, theme, and formatting ownership unless the user explicitly requests a replacement.
- Use unused mappings or explicit LazyVim namespaces. Do not override `<leader>e`, `<leader>f`, `<leader>d`, `<leader>gg`, `<leader>gB`, or `<leader>cR` without confirming the desired replacement.
- Keep `updatetime` at LazyVim's default.
- Keep global `vim.g.autoformat = false`; the overlay enables autoformat only for configured language buffers.
- Use `vim.opt.showtabline = 0` when the user means the top buffer/tab display; this hides the display without removing buffers or tab-page commands.
- Use LazyVim language extras for Mason-managed Python, TypeScript/JavaScript, Go, and Rust tooling.
- Keep organize-imports before formatting for supported language servers, while Go uses the `goimports` formatter.
- Do not port Kickstart's standalone LSP, diagnostic, Treesitter, Neo-tree, or Conform setup blocks.

## Verification

Run these checks after changes:

```sh
bash -n ~/lazyvim-custom/scripts/install.sh
stylua --check ~/lazyvim-custom/nvim/.config/nvim/lua/plugins
nvim --headless -u ~/.config/nvim/init.lua '+Lazy! sync' +qa
```

If `:Lazy! sync` reports `Failed to load plugins.theme`, inspect whether the
base Omarchy configuration has `lua/plugins/omarchy-theme-hotreload.lua` but
no `lua/plugins/theme.lua`. That is a pre-existing theme configuration issue,
not a failure of this overlay. Confirm the distinction with a normal startup
check and the direct overlay behavior checks before changing the overlay.

Then inspect:

```vim
:checkhealth
:Lazy
:set relativenumber?
:set tabstop?
:set shiftwidth?
:set showtabline?
:LspInfo
```

Test formatting, completion, Neo-tree, existing LazyVim mappings, and every newly added mapping before adding more plugins.
