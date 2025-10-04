-- Options are loaded in init.lua: require("config.options")
local opt = vim.opt

opt.number = true
opt.swapfile = false
opt.showtabline = 2
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4

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

vim.opt.tabline = "%!v:lua.MyTabLine()"

-- vim global options
vim.g.snacks_animate = false
