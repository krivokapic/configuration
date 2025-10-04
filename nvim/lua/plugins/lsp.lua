return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'saghen/blink.cmp',
    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      vim.lsp.config('clangd', {
        capabilities = capabilities,
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local c = vim.lsp.get_client_by_id(args.data.client_id)
          if not c then return end

          if vim.bo.filetype == "lua" then
            -- Format the current buffer on save
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
              end,
            })
          end
        end,
      })
    end,
  }
}
