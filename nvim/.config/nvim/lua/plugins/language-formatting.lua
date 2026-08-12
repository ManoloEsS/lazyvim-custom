local format_filetypes = {
  go = true,
  javascript = true,
  javascriptreact = true,
  python = true,
  rust = true,
  typescript = true,
  typescriptreact = true,
}

local organize_imports_filetypes = {
  javascript = true,
  javascriptreact = true,
  python = true,
  rust = true,
  typescript = true,
  typescriptreact = true,
}

local function organize_imports(buf)
  local clients = vim.lsp.get_clients({ bufnr = buf })
  for _, client in ipairs(clients) do
    if client:supports_method('textDocument/codeAction', buf) then
      local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
      params.context = {
        diagnostics = {},
        only = { 'source.organizeImports' },
      }

      local response = client:request_sync('textDocument/codeAction', params, 1000)
      local actions = response and response.result or {}
      for _, action in ipairs(actions) do
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
          return
        end
        if action.command then
          vim.lsp.buf.execute_command(action.command)
          return
        end
      end
    end
  end
end

return {
  {
    'LazyVim/LazyVim',
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('lazyvim_custom_format_filetypes', { clear = true }),
        pattern = vim.tbl_keys(format_filetypes),
        callback = function(args)
          vim.b[args.buf].autoformat = true
        end,
      })

      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('lazyvim_custom_organize_imports', { clear = true }),
        pattern = { '*.js', '*.jsx', '*.py', '*.rs', '*.ts', '*.tsx' },
        callback = function(args)
          if organize_imports_filetypes[vim.bo[args.buf].filetype] then
            organize_imports(args.buf)
          end
        end,
      })
    end,
  },
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.python = { 'ruff_format' }
      opts.formatters_by_ft.rust = { 'rustfmt' }
    end,
  },
}
