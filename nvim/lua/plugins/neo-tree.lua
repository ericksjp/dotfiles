local function getPath(state)
    local node = state.tree:get_node()
    local path = node.path
    if node.type == "file" then
        path = node:get_parent_id()
    end
    return path
end

return {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = true,
    -- keys = {
    --     {
    --         "<leader>e",
    --         function()
    --             require("utils.smart").Oil(false)
    --         end,
    --         desc = "open oil",
    --     },
    -- },
    opts = function(_, opts)
        local jackson = require("utils.ntree_helper")
        local events = require("neo-tree.events")

        local function on_move(data)
          Snacks.rename.on_rename_file(data.source, data.destination)
        end

        opts.event_handlers = opts.event_handlers or {}
        vim.list_extend(opts.event_handlers, {
          { event = events.FILE_MOVED, handler = on_move },
          { event = events.FILE_RENAMED, handler = on_move },
        })

        opts.default_component_configs = {
            indent = { with_markers = false },
        }

        opts.filesystem = vim.tbl_extend("force", opts.filesystem or {}, {
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
            bind_to_cwd = false,
            group_empty_dirs = true,
            hijack_netrw_behavior = "disabled",
            components = {
                notify_me = function(config, node, state)
                    if not jackson.is_selected(node.id) then
                        return nil
                    end

                    return {
                        text = "(X)",
                        highlight = "Comment",
                    }
                end,
            },
            renderers = {
                directory = {
                    { "indent" },
                    { "icon" },
                    { "current_filter" },
                    {
                        "container",
                        content = {
                            { "name", zindex = 10 },
                            {
                                "symlink_target",
                                zindex = 10,
                                highlight = "NeoTreeSymbolicLinkTarget",
                            },
                            { "clipboard", zindex = 10 },
                            {
                                "diagnostics",
                                errors_only = true,
                                zindex = 20,
                                align = "right",
                                hide_when_expanded = true,
                            },
                            { "git_status", zindex = 10, align = "right", hide_when_expanded = true },
                            { "file_size", zindex = 10, align = "right" },
                            { "type", zindex = 10, align = "right" },
                            { "last_modified", zindex = 10, align = "right" },
                            { "created", zindex = 10, align = "right" },
                        },
                    },
                    { "notify_me", zindex = 30, align = "right" },
                },
                file = {
                    { "indent" },
                    { "icon" },
                    {
                        "container",
                        content = {
                            {
                                "name",
                                zindex = 10,
                            },
                            {
                                "symlink_target",
                                zindex = 10,
                                highlight = "NeoTreeSymbolicLinkTarget",
                            },
                            { "clipboard", zindex = 10 },
                            { "bufnr", zindex = 10 },
                            { "modified", zindex = 20, align = "right" },
                            { "diagnostics", zindex = 20, align = "right" },
                            { "git_status", zindex = 10, align = "right" },
                            { "file_size", zindex = 10, align = "right" },
                            { "type", zindex = 10, align = "right" },
                            { "last_modified", zindex = 10, align = "right" },
                            { "created", zindex = 10, align = "right" },
                        },
                    },
                    { "notify_me", zindex = 30, align = "right" },
                },
                message = {
                    { "indent", with_markers = false },
                    { "name", highlight = "NeoTreeMessage" },
                },
                terminal = {
                    { "indent" },
                    { "icon" },
                    { "name" },
                    { "bufnr" },
                },
            },
        })

        opts.window = {
            position = "right",
            mappings = {
                ["e"] = "navigate_up",
                ["o"] = jackson.clear_selected,
                ["a"] = jackson.add_multiple_files,
                ["x"] = jackson.toggle_selected,
                ["m"] = jackson.move_items,
                ["d"] = jackson.delete_selected,
                ["f"] = "",
                ["l"] = "open",
                ["<c-x>"] = "",
                ["<localleader>d"] = function(state)
                    require("utils.pined").set_pined(getPath(state))
                end,
                ["<localleader>,"] = function(state)
                    local path = getPath(state)
                    vim.cmd("cd " .. path)
                    vim.notify("New CWD: " .. path, vim.log.levels.INFO)
                end,
                ["<tab>"] = function()
                    require("utils.smart").Neotree(true)
                end,
                ["<leader><leader>"] = function(state)
                    local path = getPath(state)
                    require("telescope.builtin").find_files({
                        no_ignore = false,
                        hidden = true,
                        cwd = path,
                        prompt_title = "Find Files - " .. path,
                    })
                end,
                ["<leader>fs"] = function(state)
                    local path = getPath(state)
                    require("telescope.builtin").live_grep({
                        cwd = path,
                        prompt_title = "Live Grep - " .. path,
                    })
                end,
                -- ["o"] = function(state)
                --   local node = state.tree:get_node()
                --   local path = node:get_parent_id()
                --   require("oil").open_float(path, {}, function()
                --     pcall(function()
                --       vim.cmd("/" .. node.name)
                --     end)
                --   end)
                -- end,
                -- ["a"] = function(state)
                --   local node = state.tree:get_node()
                --   local path = getPath(state)
                --   require("oil").open_float(path, {}, function()
                --     pcall(function()
                --       vim.cmd("/" .. node.name)
                --       vim.api.nvim_feedkeys("O", "n", true)
                --     end)
                --   end)
                -- end,
            },
        }
    end,
}
