local refresh = require("neo-tree.sources.manager").refresh

local M = {}

local selected = {}

---------------------------- add files

local function map(tbl, fn)
    local t = {}
    for k, v in ipairs(tbl) do
        t[k] = fn(k, v)
    end
    return t
end

local function to_table(iter)
    local t = {}
    for v in iter do
        t[#t + 1] = v
    end
    return t
end

local function concat(tbl1, tbl2)
    local new_tbl = {}
    local biggest_len = #tbl1 > #tbl2 and #tbl1 or #tbl2

    for i = 1, biggest_len do
        if i <= #tbl1 then
            new_tbl[#new_tbl + 1] = tbl1[i]
        end
        if i <= #tbl2 then
            new_tbl[#new_tbl + 1] = tbl2[i]
        end
    end

    return new_tbl
end

local function is_nested(input)
    local s = input:find("%b{}", 1)
    return s ~= nil
end

local function flat(input)
    if input == nil or input == "" then
        error("Input cannot be nil or empty", 2)
    end

    local s, e = input:find("%b{}", 1)
    local parent = input:sub(1, input:find("{", 1) - 1)

    if s == nil or e == nil then
        error("Input does not contain balanced braces", 2)
    end

    if parent == nil or parent == "" then
        error("Parent path cannot be nil or empty", 2)
    end

    local contend_str = input:sub(s + 1, e - 1)

    if contend_str == nil or contend_str == "" then
        error("Content string inside braces cannot be nil or empty", 2)
    end

    local normal_values = to_table(contend_str:gsub("%S+%b{}", ""):gmatch("%S+") or {})
    local nested_values = to_table(contend_str:gmatch("%S+%b{}") or {})

    local result = vim.list_extend(normal_values, nested_values)

    result = map(result, function(_, inputalue)
        return parent .. "/" .. inputalue
    end)

    return result
end

local function flatten(input)
    if input == nil or input == "" then
        error("Input cannot be nil or empty", 2)
    end

    input = input:gsub("%{", "{ ")

    local normal_values = to_table(input:gsub("%S+%b{}", ""):gmatch("%S+") or {})
    local nested_values = to_table(input:gmatch("%S+%b{}") or {})

    local temp = {}

    for _, value in ipairs(nested_values) do
        local result = flat(value)
        vim.list_extend(temp, result)
    end

    local values = concat(normal_values, temp)

    return values
end

local function has_match(input, pattern)
    local s, _ = input:find(pattern)
    return s ~= nil
end

local function is_valid(input)
    local trimmedInput = string.gsub(input or "", "%s+", "")
    if trimmedInput:len() == 0 then
        return false
    end

    local _, left_bracket_acc = trimmedInput:gsub("{", "")
    local _, right_bracket_acc = trimmedInput:gsub("}", "")

    if left_bracket_acc ~= right_bracket_acc then
        return false
    end

    if
        has_match(trimmedInput, "%//")
        or has_match(trimmedInput, "%{{")
        or has_match(trimmedInput, "%{}")
        or has_match(trimmedInput, "%}/")
        or has_match(trimmedInput, "%/{")
        or has_match(trimmedInput, "%{/")
        or has_match(input, "% {")
    then
        return false
    end

    return true
end

local function deep_flatten(input)
    if not is_valid(input) then
        error("Input string is not valid", 2)
    end

    local values = {}
    local fixed = flatten(input)

    for _, v in ipairs(fixed) do
        if not is_nested(v) then
            values[#values + 1] = v
            goto continue
        end

        for _, k in ipairs(deep_flatten(v)) do
            values[#values + 1] = k
        end

        ::continue::
    end

    return values
end

local function get_open_cmd(path)
  if vim.fn.has("mac") == 1 then
    return { "open", path }
  elseif vim.fn.has("win32") == 1 then
    if vim.fn.executable("rundll32") == 1 then
      return { "rundll32", "url.dll,FileProtocolHandler", path }
    else
      return nil, "rundll32 not found"
    end
  elseif vim.fn.executable("explorer.exe") == 1 then
    return { "explorer.exe", path }
  elseif vim.fn.executable("xdg-open") == 1 then
    return { "xdg-open", path }
  else
    return nil, "no handler found"
  end
end

---------------------------- add files

local function split_words(str, regex)
    local t = {}
    for w in string.gmatch(str, regex) do
        table.insert(t, w)
    end
    return t
end

local function parent_dir(path)
    path = path:gsub("/+$", "")
    return vim.fn.fnamemodify(path, ":h")
end

local function starts_with(str, start)
    return string.sub(str, 1, #start) == start
end

local function get_node(state)
    if state.tree ~= nil then
        return state.tree:get_node()
    end
    if state.id ~= nil and state.type ~= nil then
        return state
    end
    return nil
end

local function is_child(path)
    local j = parent_dir(path)
    while j ~= "/" do
        if M.is_selected(j) then
            Toggle_selected({ id = j, type = "" })
            break
        end
        j = parent_dir(j)
    end

    return false
end

local function has_child(path)
    for id, value in pairs(selected) do
        if id == path or value == nil then
            goto continue
        end

        if starts_with(id, path) then
            Toggle_selected({ id = id, type = "" })
        end

        ::continue::
    end
end

local function verify_peers(node)
    is_child(node.id)
    if node.type == "directory" then
        has_child(node.id)
    end
end

local function toggle_selected_current_dir(state, action_str)
    if action_str ~= "select" and action_str ~= "unselect" then
        error("Action must be: select or unselect", 2)
    end
    local action = action_str == "select" and true or nil

    local node = get_node(state)
    if node == nil then
        return
    end

    local dir_path = parent_dir(node.path)

    local pnode = nil
    for name, type in vim.fs.dir(dir_path) do
        pnode = { id = dir_path .. "/" .. name, type = type }
        selected[pnode.id] = action
        if action == true then
            verify_peers(pnode)
        end
    end
end

function Toggle_selected(state)
    local node = get_node(state)
    if node == nil then
        return
    end

    local id = node.id
    if selected[id] then
        selected[id] = nil
        return
    end

    verify_peers(node)

    selected[id] = true
end

local function get_dir(state)
    local destiny_node = state.tree:get_node()
    if destiny_node == nil then
        error("Could not get neotree node", vim.log.levels.WARN)
    end

    local destination = destiny_node.type == "directory" and destiny_node.path or parent_dir(destiny_node.path)

    if not vim.fn.isdirectory(destination) then
        error("Destination is not a directory", vim.log.levels.WARN)
    end

    return destination
end

M.create_files = function(base_path, input)
    if not is_valid(input) then
        error("invalid input", vim.log.levels.INFO)
    end

    local to_create = deep_flatten(input)

    for _, create_str in ipairs(to_create) do
        local dir_path = vim.fn.fnamemodify(base_path .. "/" .. create_str, ":h")
        vim.fn.mkdir(dir_path, "p")

        local under_path_files = vim.fn.fnamemodify(create_str, ":t")
        local files = split_words(under_path_files, "[^;]+")

        for _, file in ipairs(files) do
            local path = dir_path .. "/" .. file
            local fd = io.open(path, "w")
            if fd then
                fd:write("")
                fd:close()
            else
                vim.notify("Could not create " .. dir_path, vim.log.levels.ERROR)
            end
        end
    end
end

M.add_multiple_files = function(state)
    local tree = state.tree
    local node = tree:get_node()
    local base_path = node.type == "directory" and node.path or node:get_parent_id()

    local input = vim.fn.input("Create: ")

    local _, err = pcall(M.create_files, base_path, input)

    if err then
        vim.notify(err, vim.log.levels.INFO)
        return
    end

    refresh(state.name)
end

M.toggle_selected = function(state, callback)
    Toggle_selected(state)
    refresh("filesystem")
end

M.toggle_selected_visual = function(state, selected_nodes, callback)
    for _, node in pairs(selected_nodes) do
        verify_peers(node)
        selected[node.id] = true
    end
end

M.select_all = function(state)
    toggle_selected_current_dir(state, "select")
    refresh("filesystem")
end

M.unselect_all = function(state)
    toggle_selected_current_dir(state, "unselect")
    refresh("filesystem")
end

M.is_selected = function(node_id)
    return selected[node_id] ~= nil
end

M.get_selected_items = function(state)
    local tree = state.tree
    local selected_items = {}

    for node_id in pairs(selected) do
        local node = tree:get_node(node_id)
        if node then
            local is_dir = node.type == "directory"
            table.insert(selected_items, { id = node.id, path = node.path, name = node.name, is_dir = is_dir })
        else
            selected[node_id] = nil
        end
    end

    return selected_items
end

M.clear_selected = function()
    selected = {}
    refresh("filesystem")
end

M.opencode_selected = function(state)
    local selected_items = M.get_selected_items(state)

    require("opencode.core").open({
        new_session = false,
        focus = "input",
        start_insert = true,
    })

    local context = require("opencode.context")

    for _, file in ipairs(selected_items) do
        context.add_file(file.path)
    end

    M.clear_selected()
end

M.paste_selected = function(state)
    local destination = get_dir(state)

    local selected_items = M.get_selected_items(state)

    if #selected_items == 0 then
        vim.notify("No items selected", vim.log.levels.WARN)
        return
    end

    local choice = vim.fn.confirm(
        string.format("Paste %d selected items(s)? This action cannot be undone.", #selected_items),
        "&Paste\n&Cancel",
        2
    )

    if choice ~= 1 then
        return
    end

    local success_count = 0
    local fail_count = 0

    for _, item in ipairs(selected_items) do
        local new_path = destination .. "/" .. item.name
        local obj = nil

        if new_path == item.path then
            success_count = success_count + 1
            goto continue
        end

        -- do not override
        if vim.fn.filereadable(new_path) == 1 or vim.fn.isdirectory(new_path) == 1 then
            fail_count = fail_count + 1
            goto continue
        end

        obj = vim.system({ "cp", item.is_dir and "-r" or nil, item.path, new_path }):wait()

        if obj.code == 0 then
            success_count = success_count + 1
        else
            fail_count = fail_count + 1
        end

        ::continue::
        selected[item.id] = nil
    end

    refresh("filesystem")

    if fail_count == 0 then
        vim.notify(string.format("Successfully pasted %d item(s)", success_count), vim.log.levels.INFO)
        return
    end

    vim.notify(
        string.format("Pasted %d item(s), failed to paste %d item(s)", success_count, fail_count),
        vim.log.levels.WARN
    )
end

M.delete_selected = function(state)
    local selected_items = M.get_selected_items(state)

    if #selected_items == 0 then
        vim.notify("No items selected", vim.log.levels.WARN)
        return
    end

    -- confirm deletion
    local choice = vim.fn.confirm(
        string.format("Delete %d selected item(s)? This action cannot be undone.", #selected_items),
        "&Delete\n&Cancel",
        2
    )
    if choice ~= 1 then
        return
    end

    local success_count = 0
    local fail_count = 0

    for _, item in ipairs(selected_items) do
        local ok = pcall(function()
            if item.type == "file" then
                os.remove(item.path)
            else
                vim.fn.delete(item.path, "rf")
            end
        end)

        if ok then
            success_count = success_count + 1
        else
            fail_count = fail_count + 1
        end

        selected[item.id] = nil
    end

    -- refresh the tree
    refresh("filesystem")

    -- show result
    if fail_count == 0 then
        vim.notify(string.format("Successfully deleted %d item(s)", success_count), vim.log.levels.INFO)
    else
        vim.notify(
            string.format("Deleted %d item(s), failed to delete %d item(s)", success_count, fail_count),
            vim.log.levels.WARN
        )
    end
end

M.move_items = function(state)
    local destination = get_dir(state)

    local selected_items = M.get_selected_items(state)
    if #selected_items == 0 then
        vim.notify("No items selected", vim.log.levels.WARN)
        return
    end

    -- confirm deletion
    local choice = vim.fn.confirm(
        string.format("Move %d selected item(s)? This action cannot be undone.", #selected_items),
        "&Move\n&Cancel",
        2
    )

    if choice ~= 1 then
        return
    end

    local success_count = 0
    local fail_count = 0

    for _, item in ipairs(selected_items) do
        local new_path = destination .. "/" .. item.name
        local ok = nil

        if new_path == item.path then
            goto continue
        end

        if vim.fn.filereadable(new_path) == 1 or vim.fn.isdirectory(new_path) == 1 then
            fail_count = fail_count + 1
            goto continue
        end

        ok = pcall(function()
            os.rename(item.path, new_path)
        end)

        if ok then
            success_count = success_count + 1
        else
            fail_count = fail_count + 1
        end

        ::continue::
        selected[item.id] = nil
    end

    -- refresh the tree
    refresh("filesystem")

    -- show result
    if fail_count == 0 then
        vim.notify(string.format("Successfully moved %d item(s)", success_count), vim.log.levels.INFO)
    else
        vim.notify(
            string.format("Moved %d item(s), failed to move %d item(s)", success_count, fail_count),
            vim.log.levels.WARN
        )
    end
end

local function find_target_window(neotree_win)
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if win ~= neotree_win then
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            local bt = vim.bo[buf].buftype

            if ft ~= "neo-tree" and bt ~= "terminal" and bt ~= "prompt" then
                return win
            end
        end
    end

    return nil
end

local auto_buffer_preview = false
local last_path = nil

M.toggle_auto_buffer_preview = function()
    auto_buffer_preview = not auto_buffer_preview
    if not auto_buffer_preview then
        last_path = nil
    end

    return auto_buffer_preview
end

M.auto_buffer_preview_status = function()
    return auto_buffer_preview
end

M.open_current_node_keep_focus = function()
    vim.schedule(function()
        if not auto_buffer_preview then
            return
        end

        local ok_manager, manager = pcall(require, "neo-tree.sources.manager")
        if not ok_manager then
            return
        end

        local state = manager.get_state("filesystem")
        if not state or not state.tree then
            return
        end

        local call, node = pcall(function() return state.tree:get_node() end)
        if call and (not node or node.type ~= "file" or not node.path) then
            return
        end

        local path = node.path

        -- Avoid reopening the same file on every CursorMoved
        if path == last_path then
            return
        end

        last_path = path

        local neotree_win = vim.api.nvim_get_current_win()
        local target_win = find_target_window(neotree_win)

        -- If there is no editor window, create one
        if not target_win then
            vim.cmd("rightbelow vsplit")
            target_win = vim.api.nvim_get_current_win()

            if vim.api.nvim_win_is_valid(neotree_win) then
                vim.api.nvim_set_current_win(neotree_win)
            end
        end

        -- Load file into a buffer without changing focus
        local buf = vim.fn.bufadd(path)
        vim.fn.bufload(buf)

        if vim.api.nvim_win_is_valid(target_win) then
            vim.defer_fn(function()
                vim.api.nvim_win_set_buf(target_win, buf)
                vim.cmd("Neotree focus")
            end, 120)
        end

        -- -- Make sure focus stays in Neo-tree
        -- if vim.api.nvim_win_is_valid(neotree_win) then
        --     vim.api.nvim_set_current_win(neotree_win)
        -- end
    end)
end

M.open_external = function (state)
    local path = state.tree:get_node().path
    if not path then
        return
    end

    if vim.ui.open then
        vim.ui.open(path)
        return
    end

    local cmd, err = get_open_cmd(path)
    if not cmd then
        vim.notify(string.format("Could not open %s: %s", path, err), vim.log.levels.ERROR)
        return
    end
    local jid = vim.fn.jobstart(cmd, { detach = true })
    assert(jid > 0, "Failed to start job")
end

return M
