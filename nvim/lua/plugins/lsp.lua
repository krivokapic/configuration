return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            'saghen/blink.cmp',
        },
        opts = {
            servers = {
                lua_ls = {},
                clangd = {},
            }
        },
        config = function(_, opts)
            --local lspconfig = require('lspconfig')
            for server, config in pairs(opts.servers) do
                -- passing config.capabilities to blink.cmp merges with the capabilities in your
                -- `opts[server].capabilities, if you've defined it
                config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
                vim.lsp.config(server, {
                    capabilities = config.capabilities,
                })
            end
            -- manual way:
            -- local capabilities = require('blink.cmp').get_lsp_capabilities()
            -- vim.lsp.config('clangd', {
            --     capabilities = capabilities,
            -- })
            -- vim.lsp.config('lua_ls', {
            --     capabilities = capabilities,
            -- })


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
