return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
      local harpoon = require("harpoon")

      harpoon:setup()
      local list = harpoon:list()

      vim.keymap.set("n", "<leader>ma", function()
        list:add()
      end, { desc = "Harpoon add file" })
      vim.keymap.set("n", "<leader>mm", function()
        harpoon.ui:toggle_quick_menu(list)
      end, { desc = "Harpoon menu" })
      vim.keymap.set("n", "<A-m>", function()
        list:select(1)
      end, { desc = "Harpoon file 1" })
      vim.keymap.set("n", "<A-,>", function()
        list:select(2)
      end, { desc = "Harpoon file 2" })
      vim.keymap.set("n", "<A-.>", function()
        list:select(3)
      end, { desc = "Harpoon file 3" })
      vim.keymap.set("n", "<A-/>", function()
        list:select(4)
      end, { desc = "Harpoon file 4" })
    end,
  },
}
