-- Surgical preferences layered on top of Omarchy's LazyVim configuration.

local function setup_keymaps()
  vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
  vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
  vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines" })

  vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
  vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
  vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result" })
  vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result" })

  vim.keymap.set("n", "=ap", "ma=ap'a", { desc = "Format paragraph" })
  vim.keymap.set("x", "<leader>p", [['_dP]], { desc = "Paste without overwriting register" })
  vim.keymap.set({ "n", "v" }, "<leader>y", [=["+y]=], { desc = "Yank to clipboard" })
  vim.keymap.set("n", "<leader>Y", [=["+Y]=], { desc = "Yank line to clipboard" })
  vim.keymap.set({ "n", "v" }, "<leader>rd", [['_d]], { desc = "Delete without overwriting register" })

  -- Keep this under LazyVim's window namespace rather than replacing <leader>w.
  vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Equalize splits" })

  vim.keymap.set(
    "n",
    "<leader>a",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left><Left>]],
    { desc = "Replace word in file" }
  )
  vim.keymap.set({ "n", "v" }, "<leader>rs", "s", { desc = "Substitute" })

  vim.keymap.set("n", "<leader>ra", function()
    local ext = vim.fn.expand("%:e")
    local current_file = vim.fn.expand("%:p")

    if ext == "" or current_file == "" then
      vim.notify("The current buffer must be a named file with an extension", vim.log.levels.WARN)
      return
    end

    local view = vim.fn.winsaveview()
    local files = vim.fs.find(function(name)
      return vim.fn.fnamemodify(name, ":e") == ext
    end, { path = vim.fn.getcwd(), type = "file", limit = math.huge })

    table.sort(files)
    if #files == 0 then
      vim.notify(string.format("No .%s files found", ext), vim.log.levels.WARN)
      return
    end

    local escaped_files = vim.tbl_map(vim.fn.fnameescape, files)
    vim.cmd("args " .. table.concat(escaped_files, " "))
    vim.cmd("edit " .. vim.fn.fnameescape(current_file))
    vim.fn.winrestview(view)
    vim.notify(string.format("Loaded %d .%s files into args", #files, ext))
  end, { desc = "Load same-extension files into args" })

  vim.keymap.set("n", "<leader>rp", function()
    vim.fn.setreg("/", "\\<" .. vim.fn.expand("<cword>") .. "\\>")
    vim.cmd("set hlsearch")
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(
        [[:argdo %s/\<<C-r><C-w>\>//gc | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]],
        true,
        false,
        true
      ),
      "n",
      false
    )
  end, { desc = "Replace word in args" })
end

return {
  -- This init hook runs early enough to override Omarchy's base options.
  {
    "LazyVim/LazyVim",
    init = function()
      vim.g.autoformat = false
      vim.opt.clipboard = {}
      vim.opt.relativenumber = true
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.showtabline = 0
      vim.filetype.add({ extension = { gotmpl = "gotmpl" } })

      -- Schedule after LazyVim's VeryLazy handler installs its default mappings.
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = vim.schedule_wrap(setup_keymaps),
      })
    end,
  },
}
