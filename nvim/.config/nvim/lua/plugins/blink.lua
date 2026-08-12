return {
  {
    'saghen/blink.cmp',
    opts = {
      keymap = {
        ['<Tab>'] = false,
        ['<S-Tab>'] = false,
        ['<C-.>'] = { 'snippet_forward', 'fallback' },
        ['<C-,>'] = { 'snippet_backward', 'fallback' },
      },
    },
  },
}
