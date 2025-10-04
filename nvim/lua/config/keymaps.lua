-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
map("n", "<leader><SPACE>", function() require("fzf-lua").files() end, { desc = "Fuzzy find files" })
map("n", "<leader>g", function() require("fzf-lua").git_files() end, { desc = "Fuzzy find git files" })
map("n", "<leader>f", function() require("fzf-lua").live_grep() end, { desc = "rg search" })
map("n", "<leader>w", function() require("fzf-lua").grep_cword() end, { desc = "rg search current word" })
map({"i","v"}, "<C-c>", "<Esc>", {noremap = true, silent = true})
map("n", "L", 'gt')
map("n", "H", 'gT')
-- grep search the selected text when in visual mode
map("v", "<leader>f", function()
  -- use normal! gv to reselect the last visual area and yank it to a register
  -- but instead, we just manually read the selection range
  local mode = vim.fn.mode()
  if mode:find("v") then
    -- get range while still in visual mode
    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getpos(".")
    if start_pos[2] > end_pos[2] or (start_pos[2] == end_pos[2] and start_pos[3] > end_pos[3]) then
      start_pos, end_pos = end_pos, start_pos
    end

    local sr, sc = start_pos[2], start_pos[3]
    local er, ec = end_pos[2], end_pos[3]

    -- extract text without sending <Esc>
    local lines = vim.fn.getline(sr, er)
    if #lines == 0 then return end
    lines[#lines] = string.sub(lines[#lines], 1, ec)
    lines[1] = string.sub(lines[1], sc)
    local selection = table.concat(lines, "\n")

    -- optionally escape regex characters for literal search
    selection = vim.fn.escape(selection, [[\.*$^~[]])

    -- now run fzf-lua search
    require("fzf-lua").grep({ search = selection })
  end
end, { desc = "Ripgrep search for visual selection" })


