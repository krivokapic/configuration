local opt = vim.o
local map = vim.keymap.set

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

map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })
map({ "n" }, "<C-p>", '"+p<CR>', { desc = "System clipboard yank." })
map({ "i" }, "<C-p>", '<C-r>+', { desc = "System clipboard yank." })
map({ "i", "v" }, "<C-c>", "<Esc>", { noremap = true, silent = true })
map({ "n", "v", "x" }, "<C-s>", [[:s/\V]], { desc = "Enter substitue mode in selection" })
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
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

vim.pack.add({
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/ellisonleao/gruvbox.nvim'
})

vim.lsp.enable('gopls')
vim.lsp.enable('lua_ls')

vim.cmd.colorscheme('gruvbox')


-- 1. Disable default inline virtual text
-- vim.diagnostic.config({
--   virtual_text = false, -- Hides text at end of lines
--   signs = true,         -- Keeps gutter icons (E, W, I)
--   underline = true,     -- Keeps underlines
-- })

-- 2. Keybind to show diagnostics for the current line only
-- Replace "<leader>d" with your preferred key
map("n", "<leader>d", function() vim.diagnostic.open_float(nil, { scope = "line" }) end,
    { desc = "Show line diagnostics" })
    
-- 1. Enable LSP completion (usually in LspAttach)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.lsp.completion.enable(true, args.data.client_id, args.buf, {
      autotrigger = true, -- Disable auto-trigger if you want manual only
    })
  end,
})

-- 2. Map Ctrl+N in insert mode to MANUALLY request completions
map("i", "<C-n>", function() vim.lsp.completion.get() end, { desc = "Trigger LSP Completion" })


-- 1. Set a global border for ALL floating windows (Simplest Method)
-- This applies to hover, signature_help, and diagnostics automatically
vim.opt.winborder = "rounded" 

-- Alternatively, configure ONLY signature_help explicitly without vim.lsp.with:
-- vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, context, config)
--   -- Merge default handler with custom border config
--   vim.lsp.handlers.signature_help(err, result, context, vim.tbl_extend("force", config or {}, {
--     border = "rounded",
--     focusable = false,
--     close_events = { "CursorMoved", "BufHidden", "InsertCharPre" },
--   }))
-- end

-- 2. Manual Keybind (Ctrl+K)
map("i", "<C-k>", function() vim.lsp.buf.signature_help() end, { desc = "Show Signature Help" })

-- 3. Auto-trigger ONLY when typing '('
vim.api.nvim_create_autocmd("InsertCharPre", {
  pattern = "*",
  callback = function()
    if vim.v.char == "(" then
      vim.lsp.buf.signature_help()
    end
  end,
  desc = "Trigger signature help on bracket",
})

