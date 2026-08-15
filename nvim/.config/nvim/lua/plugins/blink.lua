return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        -- Explicit fallback entries prevent LazyVim from restoring snippet navigation.
        ["<Tab>"] = { "fallback" },
        ["<S-Tab>"] = { "fallback" },
        ["<C-.>"] = { "snippet_forward", "fallback" },
        ["<C-,>"] = { "snippet_backward", "fallback" },
      },
    },
  },
}
