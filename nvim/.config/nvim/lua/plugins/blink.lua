return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        -- Keep Enter as a normal newline; confirm completions with Ctrl-y.
        ["<CR>"] = false,
        ["<C-y>"] = { "select_and_accept" },
        ["<Tab>"] = { "fallback" },
        ["<S-Tab>"] = { "fallback" },
        ["<C-.>"] = { "snippet_forward", "fallback" },
        ["<C-,>"] = { "snippet_backward", "fallback" },
      },
    },
  },
}
