local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set
local opt = vim.opt
local godocs = require('godocs')

-- globals
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.snacks_animate = false

-- options
opt.number = true
opt.swapfile = false
opt.showtabline = 2
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.incsearch = false
opt.confirm = true
opt.ignorecase = true
opt.smartcase = true
-- vim.diagnostic.config({ virtual_text = true })
opt.completeopt = { "menu", "menuone", "noselect", "popup" }
opt.winborder = "rounded"

-- get plugins
vim.pack.add({
    { src = "https://github.com/ellisonleao/gruvbox.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/ibhagwan/fzf-lua",                version = "main" },
    { src = "https://github.com/stevearc/oil.nvim", },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://codeberg.org/ziglang/zig.vim" }
})

vim.g.zig_fmt_parse_errors = 0
vim.g.zig_fmt_autosave = 0

require("gruvbox").setup()
require("oil").setup({
    opts = {},
    -- Optional dependencies
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
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
        ["<CR>"] = { "actions.select", opts = { tab = true } },
        ["L"] = {
            callback = function()
                local oil = require("oil")
                local node = oil.get_cursor_entry()
                if node.type == "directory" then
                    oil.select()
                end
            end,
            mode = "n",
            desc = "Navigate into directory"
        },
        ["H"] = { "actions.parent", mode = "n" },
    },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
})
vim.cmd.colorscheme("gruvbox")

local fzf = require("fzf-lua")

fzf.setup({
    keymap = {
        builtin = true,
        fzf = {
            ["ctrl-q"] = "select-all+accept",
        },
    },
})


require("nvim-treesitter").setup({
    ensure_installed = { "go", "c", "python", "javascript", "typescript" },
    highlight = {
        enable = true, -- Toggles native high-performance highlighting on
    },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "go", "lua", "c", "python", "javascript", "typescript" },
    callback = function()
        vim.treesitter.start()
    end,
})

-- remove trailing whitespace on all lines to keep diffs cleaner
local dummy_group = vim.api.nvim_create_augroup('dummy_group', {})
vim.api.nvim_create_autocmd("BufWritePre", {
    group = dummy_group,
    pattern = "*",
    callback = function()
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})

-- blink when yank
local yank_group = vim.api.nvim_create_augroup('HighlightYank', {})
autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 100, -- ms
        })
    end,
})

vim.lsp.enable("gopls")
vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".git", "init.lua" },

    settings = {
        Lua = {
            diagnostics = {
                -- Stops Neovim from highlighting 'vim' as an undefined global variable
                globals = { "vim" }
            },
            workspace = {
                -- Prevents the server from scanning huge third-party library paths
                checkThirdParty = false,
            }
        }
    }
})

vim.lsp.enable("lua_ls")

vim.lsp.config("zls", {
    cmd = { "zls" },
    filetypes = { "zig" },
    root_markers = { "build.zig" },
    settings = {
        zls = {
            enable_build_on_save = true,
        }
    }
})
vim.lsp.enable("zls")

-- format files automatically on save
autocmd("BufWritePre", {
    pattern = { "*.zig", "*.zon", "*.lua", "*.go" },
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})


-- lsp keybinds
autocmd('LspAttach', {
    group = dummy_group,
    callback = function(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if client == nil then return end

        if client:supports_method("textDocument/completion") then
            if client.server_capabilities.completionProvider then
                local triggers = client.server_capabilities.completionProvider.triggerCharacters or {}
                -- Add standard alphabet characters so completion doesn't vanish on type
                for i = string.byte('a'), string.byte('z') do
                    table.insert(triggers, string.char(i))
                end
                for i = string.byte('A'), string.byte('Z') do
                    table.insert(triggers, string.char(i))
                end
                client.server_capabilities.completionProvider.triggerCharacters = triggers
            end
            vim.lsp.completion.enable(true, client.id, e.buf, { autotrigger = true })
        end

        local opts = { buffer = e.buf }
        map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "K", vim.lsp.buf.hover, opts)
        map("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        -- map("n", "<leader>vd", vim.diagnostic.open_float, opts)
        -- show diagnostics for the current line only
        map("n", "<leader>d", function() vim.diagnostic.open_float(nil, { scope = "line" }) end)
        map("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        map("n", "<leader>vrr", vim.lsp.buf.references, opts)
        map("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        map("i", "<C-h>", vim.lsp.buf.signature_help, opts)
        map("n", "[d", vim.diagnostic.goto_next, opts)
        map("n", "]d", vim.diagnostic.goto_prev, opts)
        map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, opts)
    end
})

-- keybinds
map({ "n", "v", "x" }, "<leader>o", "<Cmd>source %<CR>", { desc = "Source nvim config" .. vim.fn.expand("$MYVIMRC") })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })
map({ "n" }, "<C-p>", '"+p<CR>', { desc = "System clipboard yank." })
map({ "i" }, "<C-p>", '<C-r>+', { desc = "System clipboard yank." })
map({ "i", "v" }, "<C-c>", "<Esc>", { noremap = true, silent = true })
map({ "n", "v", "x" }, "<C-s>", [[:%s/\V//g<Left><Left><Left>]], { desc = "Global search and replace" })
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map({ "n" }, "<leader>e", "<cmd>Oil --float<CR>", { desc = "Format current buffer" })
map({ "n" }, "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
map({ "n" }, "<leader>gd", function()
    local current_buf = vim.api.nvim_get_current_buf()

    vim.lsp.buf.definition({
        on_list = function(options)
            local items = options.items or {}
            if #items == 0 then
                return
            end

            local target = items[1]
            local target_buf = vim.fn.bufnr(target.filename, true)

            if target_buf == current_buf then
                -- Scenario 1: Definition is in the current buffer
                if target.lnum then
                    vim.api.nvim_win_set_cursor(0, { target.lnum, (target.col or 1) - 1 })
                end
            else
                -- Scenario 2: Definition is in a different buffer
                -- Check if any existing window is already displaying that buffer
                local win_found = false
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    if vim.api.nvim_win_get_buf(win) == target_buf then
                        -- Found an open window with this buffer; switch to it
                        vim.api.nvim_set_current_win(win)
                        win_found = true
                        break
                    end
                end

                -- Scenario 3: Buffer is NOT open anywhere; create a new tab
                if not win_found then
                    vim.cmd("tab split")
                    vim.cmd("edit " .. vim.fn.fnameescape(target.filename))
                end

                -- Jump to the target position in whichever window we ended up in
                if target.lnum then
                    vim.api.nvim_win_set_cursor(0, { target.lnum, (target.col or 1) - 1 })
                end
            end
        end,
    })
end, { desc = "Go to definition" })

map({ "n" }, "<leader>k", vim.lsp.buf.signature_help, { desc = "Show function signature" })
map({ "x" }, "p", '"_dP', { desc = "Paste without losing yanked text" })
map("n", "L", 'gt')
map("n", "H", 'gT')
map("n", "<C-l>", ':tabm +1<CR>')
map("n", "<C-h>", ':tabm -1<CR>')
map("i", "{<tab>", '{}<Left>')
map("i", "{<tab>", '{}<Left>')
map("i", '"', '""<left>')
map("i", "'", "''<left>")
map("i", '<C-">', '"<left>')
map("i", "<C-'>", "'<left>")
map("i", "(", '()<left>')
map("i", "[", '[]<left>')
map("i", "{<tab>", '{}<Left>')
map("i", "{<CR>", '{<CR>}<ESC>O')
map("i", "{;<CR>", '{<CR>};<ESC>O')
map("i", "<C-l>", '<Right>')
map("i", "<C-h>", '<Left>')
map("i", "<C-j>", '<Down>')
map("i", "<C-k>", '<Up>')
map("n", "]q", '<Cmd>cn<CR>')
map("n", "[q", '<Cmd>cn<CR>')
map("n", "<C-d>", '<C-d>zz')
map("n", "<C-u>", '<C-u>zz')
map("c", "<C-l>", '<Right>')
map("c", "<C-h>", '<Left>')

-- fzf-lua keybinds
map("n", "<leader><SPACE>", function() require("fzf-lua").files() end, { desc = "Fuzzy find files" })
map("n", "<leader>g", function() require("fzf-lua").git_files() end, { desc = "Fuzzy find git files" })
--map("n", "<leader>f", function() require("fzf-lua").lsp_references() end, { desc = "rg search" })
map("n", "<leader>w", function() require("fzf-lua").grep_cword() end, { desc = "rg current word under cursor" })
map("n", "<leader>f", function() require("fzf-lua").live_grep() end, { desc = "rg search" })
map("v", "<leader>f", function() require("fzf-lua").grep_visual() end, { desc = "rg visual selection" })
map("n", "<leader>sh", function() require("fzf-lua").helptags() end, { desc = "helptags" })
map("n", "<leader>sm", function() require("fzf-lua").manpages() end, { desc = "manpages" })
map("n", "<leader>sn", function() require("fzf-lua").nvim_options() end, { desc = "nvim_options" })
map("n", "<leader>sk", function() require("fzf-lua").keymaps() end, { desc = "keymaps" })
map("n", "<leader>lw", function() require("fzf-lua").diagnostics_document() end, { desc = "LSP diagnostics" })
map("n", "<leader>q", "<Cmd>copen<CR>", { desc = "open quickfix" })
map("n", "<leader>c", "<Cmd>cclose<CR>", { desc = "close quickfix" })
map("n", "<leader>x", "<Cmd>cexpr []<CR>", { desc = "empty quickfix" })
map("i", "<C-n>", "<C-x><C-o>", { desc = "lsp suggestion" })
map("n", "<leader>sd", godocs.browse_go_doc, { desc = "search go docs" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        map("n", "<leader>r", ":cfdo %s///g | update<C-Left><C-Left><Left><Left><Left><Left>",
            { buffer = true })
        map({ "x", "c" }, "<C-l>", "<Right>", { buffer = true })
        map({ "x", "c" }, "<C-h>", "<Left>", { buffer = true })
    end,
})

function MyTabLabel(n)
    local buflist = vim.fn.tabpagebuflist(n)
    local winnr = vim.fn.tabpagewinnr(n)
    local buf = buflist[winnr]
    local name = vim.fn.bufname(buf)
    return vim.fn.fnamemodify(name, ":t")
end

function MyTabLine()
    local s = ""
    for i = 1, vim.fn.tabpagenr('$') do
        local label = MyTabLabel(i)
        if i == vim.fn.tabpagenr() then
            s = s .. "%#TabLineSel# " .. label .. " "
        else
            s = s .. "%#TabLine# " .. label .. " "
        end
    end
    return s
end

opt.tabline = "%!v:lua.MyTabLine()"
