return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        commands = {
          open_and_close = function(state)
            local commands = require("neo-tree.sources.filesystem.commands")
            local node = state.tree:get_node()

            commands.open(state)
            if node and node.type ~= "directory" then
              require("neo-tree.command").execute({ action = "close", source = "filesystem" })
            end
          end,
        },
        window = {
          mappings = {
            ["<cr>"] = "open_and_close",
            ["l"] = "open_and_close",
          },
        },
      },
    },
  },
}
