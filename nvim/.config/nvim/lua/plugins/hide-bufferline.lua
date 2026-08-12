-- Keep Bufferline's commands available without displaying its tabline.
return {
  {
    'akinsho/bufferline.nvim',
    init = function()
      vim.opt.showtabline = 0
    end,
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.auto_toggle_bufferline = false
      opts.options.always_show_bufferline = false
    end,
  },
}
