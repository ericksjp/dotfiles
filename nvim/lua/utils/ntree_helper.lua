local neotree_input = require("neo-tree.ui.inputs").input

local M = {}

local selected = {}

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
            Ts({ id = j, type = "" })
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
            Ts({ id = id, type = "" })
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

function Ts(state)
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

M.add_multiple_files = function(state)
    local tree = state.tree
    local node = tree:get_node()
    local base_path = node.type == "directory" and node.path or node:get_parent_id()

    neotree_input("add multiple files (space separated)", "", function(input)
        if not input or input == "" then
            return
        end

        local to_create = split_words(input, "%S+")

        for _, create_str in ipairs(to_create) do
            local dir_path = vim.fn.fnamemodify(base_path .. "/" .. create_str, ":h")
            vim.fn.mkdir(dir_path, "p")

            local under_path_files = vim.fn.fnamemodify(create_str, ":t")
            local files = split_words(under_path_files, "[^;]+");

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

        require("neo-tree.sources.manager").refresh(state.name)
    end)
end

M.toggle_selected = function(state, callback)
    Ts(state)
    require("neo-tree.sources.manager").refresh("filesystem")
end

M.toggle_selected_visual = function(state, selected_nodes, callback)
    for _, node in pairs(selected_nodes) do
        verify_peers(node)
        selected[node.id] = true
    end
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
            table.insert(selected_items, {id = node.id, path = node.path, name = node.name});
        else
            selected[node_id] = nil
        end
    end

    return selected_items
end

M.clear_selected = function()
    selected = {}
    require("neo-tree.sources.manager").refresh("filesystem")
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
    require("neo-tree.sources.manager").refresh("filesystem")

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
    local destiny_node = state.tree:get_node()
    if destiny_node == nil then
        return
    end
    local destination = destiny_node.type == "directory" and destiny_node.path or parent_dir(destiny_node.path)
    if not vim.fn.isdirectory(destination) then
        vim.notify("Destination is not a directory", vim.log.levels.WARN)
    end

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
    require("neo-tree.sources.manager").refresh("filesystem")

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

return M
