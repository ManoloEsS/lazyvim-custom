return {
  {
    "mikavilpas/yazi.nvim",
    init = function()
      -- Let Yazi handle directory arguments instead of netrw.
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      open_for_directories = true,
      set_keymappings_function = function(yazi_buffer)
        vim.keymap.set("t", "\\", "q", { buffer = yazi_buffer, desc = "Close Yazi" })
      end,
    },
    keys = {
      { "\\", "<cmd>Yazi<cr>", desc = "Yazi file manager" },
    },
  },
}
