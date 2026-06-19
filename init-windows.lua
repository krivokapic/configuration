package.path = package.path .. ";C:/Users/Vladimir/AppData/Local/Nvim/?.lua"

local opt = vim.o
local map = vim.keymap.set
local godocs = require('godocs')

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

opt.number = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = false

opt.termguicolors = true
opt.showmatch = true

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 300

opt.completeopt = "menu,menuone,noselect,popup"
opt.winborder = "rounded"

map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })
map({ "n" }, "<C-p>", '"+p<CR>', { desc = "System clipboard yank." })
map({ "i" }, "<C-p>", '<C-r>+', { desc = "System clipboard yank." })
map({ "i", "v" }, "<C-c>", "<Esc>", { noremap = true, silent = true })
map({ "n", "v", "x" }, "<C-s>", [[:s/\V]], { desc = "Enter substitue mode in selection" })
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map({ "n" }, "<leader>e", "<cmd>Oil --float<CR>", { desc = "Format current buffer" })
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
map("i", "<C-j>", '<Up>')
map("i", "<C-k>", '<Down>')
map("n", "]q", '<Cmd>cn<CR>')
map("n", "[q", '<Cmd>cn<CR>')
map("n", "<C-d>", '<C-d>zz')
map("n", "<C-u>", '<C-u>zz')

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
map("n", "<leader>sd", godocs.browse_go_doc, { desc = "search go docs" })

vim.pack.add({
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/ellisonleao/gruvbox.nvim',
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/stevearc/oil.nvim"
})

vim.lsp.enable('gopls')
vim.lsp.enable('lua_ls')

vim.cmd.colorscheme('gruvbox')

require("fzf-lua").setup({
    winopts = {
        height = 1.0,
        width = 1.0,
    }
})



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
        ["<CR>"] = { "actions.select", opts = { tab = true } },
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


-- show diagnostics for the current line only
map("n", "<leader>d", function() vim.diagnostic.open_float(nil, { scope = "line" }) end,
    { desc = "Show line diagnostics" })

-- enable LSP completion
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        vim.lsp.completion.enable(true, args.data.client_id, args.buf, {
            autotrigger = true,
        })
    end,
})

-- request lsp completions
map("i", "<C-n>", function() vim.lsp.completion.get() end, { desc = "Trigger LSP Completion" })
-- show function signature
map({ "i", "n" }, "<C-k>", function() vim.lsp.buf.signature_help() end, { desc = "Show Signature Help" })

-- show signature help when typing '('
vim.api.nvim_create_autocmd("InsertCharPre", {
    pattern = "*",
    callback = function()
        if vim.v.char == "(" then
            vim.lsp.buf.signature_help()
        end
    end,
    desc = "Trigger signature help on bracket",
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
