local map = vim.keymap.set

map({ "n", "v", "x" }, "<leader>o", "<Cmd>source %<CR>", { desc = "Source nvim config" .. vim.fn.expand("$MYVIMRC") })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })
map({ "i", "v" }, "<C-c>", "<Esc>", { noremap = true, silent = true })
map({ "n", "v", "x" }, "<C-s>", [[:s/\V]], { desc = "Enter substitue mode in selection" })
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map({ "n" }, "<leader>e", "<cmd>Oil --float<CR>", { desc = "Format current buffer" })
map({ "n" }, "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })


map("n", "L", 'gt')
map("n", "H", 'gT')
map("n", "<C-l>", ':tabm +1<CR>')
map("n", "<C-h>", ':tabm -1<CR>')

map("i", "{<tab>", '{}<Left>')
map("i", "{<tab>", '{}<Left>')
map("i", '"', '""<left>')
map("i", "'", "''<left>")
map("i", "(", '()<left>')
map("i", "[", '[]<left>')
map("i", "{<tab>", '{}<Left>')
map("i", "{<CR>", '{<CR>}<ESC>O')
map("i", "{;<CR>", '{<CR>};<ESC>O')
map("i", "<C-l>", '<Right>')
map("i", "<C-h>", '<Left>')
map("i", "<C-j>", '<Up>')
map("i", "<C-k>", '<Down>')
map("i", "]q", '<Cmd>cn<CR>')
map("i", "[q", '<Cmd>cn<CR>')

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

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.keymap.set("n", "<leader>r", ":cfdo %s///g | update<C-Left><C-Left><Left><Left><Left><Left>",
            { buffer = true })
        vim.keymap.set({ "x", "c" }, "<C-l>", "<Right>", { buffer = true })
        vim.keymap.set({ "x", "c" }, "<C-h>", "<Left>", { buffer = true })
    end,
})
-- map("n", "<leader>q", function() require("fzf-lua").quickfix() end, { desc = "quickfix" })

-- grep search the selected text when in visual mode
--map("v", "<leader>f", function()
--    -- use normal! gv to reselect the last visual area and yank it to a register
--    -- but instead, we just manually read the selection range
--    local mode = vim.fn.mode()
--    if mode:find("v") then
--        -- get range while still in visual mode
--        local start_pos = vim.fn.getpos("v")
--        local end_pos = vim.fn.getpos(".")
--        if start_pos[2] > end_pos[2] or (start_pos[2] == end_pos[2] and start_pos[3] > end_pos[3]) then
--            start_pos, end_pos = end_pos, start_pos
--        end
--
--        local sr, sc = start_pos[2], start_pos[3]
--        local er, ec = end_pos[2], end_pos[3]
--
--        -- extract text without sending <Esc>
--        local lines = vim.fn.getline(sr, er)
--        if #lines == 0 then return end
--        lines[#lines] = string.sub(lines[#lines], 1, ec)
--        lines[1] = string.sub(lines[1], sc)
--        local selection = table.concat(lines, "\n")
--
--        -- optionally escape regex characters for literal search
--        selection = vim.fn.escape(selection, [[\.*$^~[]])
--
--        -- now run fzf-lua search
--        require("fzf-lua").grep({ search = selection })
--    end
--end, { desc = "Ripgrep search for visual selection" })
