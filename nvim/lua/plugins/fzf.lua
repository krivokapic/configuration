return {
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        -- or if using mini.icons/mini.nvim
        -- dependencies = { "nvim-mini/mini.icons" },
        opts = {},
        config = function()
            require("fzf-lua").setup({
                keymap = {
                    true,
                    fzf = {
                        ["ctrl-q"] = "select-all+accept",
                    },
                },
                -- actions = {
                --     true,
                --     files = {
                --         ["enter"] = FzfLua.actions.file_tabedit,
                --         ["alt-q"] = FzfLua.actions.file_sel_to_qf
                --     }
                -- },
                winopts = {
                    height = 1.0,
                    width = 1.0,
                }
            })
        end,
    }
}
