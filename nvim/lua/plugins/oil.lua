return {
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        -- Optional dependencies
        dependencies = { { "nvim-mini/mini.icons", opts = {} } },
        config = function()
            -- custom function to select a directory 
            local oil = require("oil")
            local function custom_open_dir()
                local node = oil.get_cursor_entry()
                if node.type == "directory" then
                    oil.select()
                end
            end

            require("oil").setup({
                lsp_file_methods = {
                    enabled = true,
                    tiimeout_ms = 1000,
                    autosave_changes = true
                },
                columns = { "icon" },
                float = {
                    max_width = 0.7,
                    max_height = 0.6,
                    border = "rounded"
                },
                view_options = {
                    show_hidden = true
                },
                keymaps = {
                    ["<CR>"] = { "actions.select", opts = { tab = true }},
                    ["L"] = { 
                        callback = function()
                            custom_open_dir()
                        end,
                        mode = "n",
                        desc = "Navigate into directory"
                    },
                    ["H"] = { "actions.parent", mode = "n" },
                }
            })
        end,
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,
    }
}
