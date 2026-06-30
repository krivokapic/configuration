local M = {}

local GO_SRC_ROOT = "/usr/local/go/src"

local function get_go_modules()
    local modules = {}
    local function traverse(dir_path, current_prefix)
        for name, type in vim.fs.dir(dir_path) do
            if type == 'directory' then
                if name ~= "vendor" and name ~= "cmd" and name ~= "test" and name ~= "internal" and name ~= "builtin" then
                    local rel_path = current_prefix == "" and name or (current_prefix .. "/" .. name)
                    table.insert(modules, rel_path)
                    traverse(dir_path .. "\\" .. name, rel_path)
                end
            end
        end
    end
    traverse(GO_SRC_ROOT, "")
    table.sort(modules)
    return modules
end

local function get_module_methods(module_rel_path)
    local items = {}
    local full_dir_path = GO_SRC_ROOT .. "/" .. module_rel_path -- :gsub("/", "\\")
    if vim.fn.isdirectory(full_dir_path) == 0 then return items end

    for name, type in vim.fs.dir(full_dir_path) do
        if type == 'file' and name:match("%.go$") and not name:match("_test%.go$") then
            local file_path = full_dir_path .. "/" .. name
            local line_num = 1
            local f = io.open(file_path, "r")
            if f then
                for line in f:lines() do
                    if line:match("^func ") then
                        local clean_line = line:gsub("{", ""):gsub("%s+$", "")
                        --local display_str = string.format("%s", clean_line)
                        local display_str = string.format("%s:%d:%s", name, line_num, clean_line)
                        table.insert(items, display_str)
                    end
                    line_num = line_num + 1
                end
                f:close()
            end
        end
    end
    return items
end

function M.browse_go_doc()
    local fzf_status, fzf = pcall(require, "fzf-lua")
    if not fzf_status then
        vim.notify("fzf-lua plugin is required for this feature!", vim.log.levels.ERROR)
        return
    end

    local modules = get_go_modules()
    if #modules == 0 then
        vim.notify("No Go modules found. Check your GO_SRC_ROOT path.", vim.log.levels.WARN)
        return
    end

    fzf.fzf_exec(modules, {
        prompt = 'Go Modules> ',
        winopts = { height = 0.70, width = 0.50 },
        fzf_opts= {
            ["--exact"] = true,
        },
        actions = {
            ["default"] = function(selected)
                if not selected or #selected == 0 then return end
                local chosen_module = selected[1]
                local methods = get_module_methods(chosen_module)

                if #methods == 0 then
                    vim.notify("No methods found in package: " .. chosen_module, vim.log.levels.INFO)
                    return
                end

                local module_dir = GO_SRC_ROOT .. "/" .. chosen_module -- :gsub("/", "\\")
                -- local module_dir = GO_SRC_ROOT .. "\\" .. chosen_module:gsub("/", "\\")

                fzf.fzf_exec(methods, {
                    prompt = chosen_module .. '>',
                    -- prompt = chosen_module .. ' Methods> ',
                    cwd = module_dir,
                    previewer = "builtin",
                    fzf_opts= {
                        ["--exact"] = true,
                    },
                    winopts = {
                        height = 0.85,
                        width = 0.85,
                        preview = {
                            layout = 'horizontal',
                            horizontal = 'right:55%',
                        }
                    },
                    actions = {
                        ["ctrl-t"] = function(method_selection)
                            if not method_selection or #method_selection == 0 then return end

                            local filename, line = method_selection[1]:match("^([^:]+):(%d+)")
                            if filename and line then
                                local full_file_path = module_dir .. "/" .. filename
                                -- local full_file_path = module_dir .. "\\" .. filename
                                vim.cmd("tabnew")
                                vim.cmd("edit " .. vim.fn.fnameescape(full_file_path))
                                vim.api.nvim_win_set_cursor(0, { tonumber(line), 0 })
                            end
                        end
                    }
                })
            end
        }
    })
end

return M
