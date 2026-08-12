return {
  {
    'mikavilpas/yazi.nvim',
    init = function()
      -- Let Yazi handle directory arguments instead of netrw.
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      open_for_directories = true,
    },
    keys = {
      { '\\', '<cmd>Yazi<cr>', desc = 'Yazi file manager' },
    },
  },
}
