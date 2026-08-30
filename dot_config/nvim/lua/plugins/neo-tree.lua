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
        local ntree_helper = require("utils.ntree_helper")
        local events = require("neo-tree.events")

        vim.api.nvim_set_hl(0, "NeoTreeNotifyMe", {
            fg = "#ffffff",
            bold = true,
        })

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
                marked = function(config, node, state)
                    if not ntree_helper.is_selected(node.id) then
                        return { text = "" }
                    end

                    return {
                        text = "●",
                        highlight = "NeoTreeNotifyMe",
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
                            { "marked", zindex = 10, align = "left" },
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
                },
                file = {
                    { "indent" },
                    { "icon" },
                    {
                        "container",
                        content = {
                            { "marked", zindex = 10, align = "left" },
                            { "name", zindex = 10 },
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

        -- opts.event_handlers = {
        --     {
        --         event = "file_opened",
        --         handler = function(path)
        --             if path and path:match("%.md$") then
        --                 vim.cmd("Neotree focus")
        --             end
        --         end,
        --     },
        -- }

        opts.commands = opts.commands or {}

        opts.commands.toggle_auto_buffer_preview = function()
            local status = ntree_helper.toggle_auto_buffer_preview()

            if status then
                -- vim.cmd("MarkdownPreview")
                vim.notify("Neo-tree buffer preview: ON")
                ntree_helper.open_current_node_keep_focus()
            else
                -- vim.cmd("MarkdownPreviewStop")
                vim.notify("Neo-tree buffer preview: OFF")
            end
        end

        local group = vim.api.nvim_create_augroup("NeoTreeAutoBufferPreview", {
            clear = true,
        })

        vim.api.nvim_create_autocmd("CursorMoved", {
            group = group,
            callback = function()
                local ft = vim.bo.filetype
                if ft ~= "neo-tree" then
                    return
                end

                ntree_helper.open_current_node_keep_focus()
            end,
        })

        opts.window = {
            position = "left",
            mappings = {
                ["e"] = "navigate_up",
                ["w"] = ntree_helper.toggle_selected, -- toggle selection of the current file/directory
                ["<C-a>"] = ntree_helper.select_all, -- select all files in the current node directory
                ["u"] = ntree_helper.unselect_all, -- unselect all files in the current node directory
                ["<C-u>"] = ntree_helper.clear_selected, -- clear all selected
                ["a"] = ntree_helper.add_multiple_files,
                ["m"] = ntree_helper.move_items,
                ["d"] = ntree_helper.delete_selected,
                ["P"] = "toggle_auto_buffer_preview",
                ["o"] = ntree_helper.opencode_selected,
                ["f"] = "",
                ["l"] = function(state)
                    local node = state.tree:get_node()
                    if node.type == "directory" then
                        require("neo-tree.sources.filesystem.commands").toggle_node(state)
                    else
                        require("neo-tree.sources.filesystem.commands").open(state)
                        pcall(vim.cmd("Neotree focus"))
                    end
                end,
                ["<C-f>"] = "filter_on_submit",
                ["<localleader>d"] = function(state)
                    require("utils.pined").set_pined(getPath(state))
                end,
                ["<localleader>e"] = ntree_helper.open_external,
                ["<localleader>,"] = function(state)
                    local path = getPath(state)
                    vim.cmd("cd " .. path)
                    vim.notify("New CWD: " .. path, vim.log.levels.INFO)
                end,
                ["<tab>"] = function()
                    require("utils.smart").Neotree(true)
                end,
                ["<localleader>f"] = function(state)
                    local dir = getPath(state)

                    if not dir or dir == "" then
                        vim.notify("Error getting current directory", vim.log.levels.ERROR)
                        return
                    end

                    vim.system({ "xdg-open", dir }, {}, function(result)
                        if result.code ~= 0 then
                            vim.notify("Error opening file explorer: " .. result.stderr, vim.log.levels.ERROR)
                            return
                        end
                    end)
                end,
                -- ["<leader><leader>"] = function(state)
                --     local path = getPath(state)
                --     require("telescope.builtin").find_files({
                --         no_ignore = false,
                --         hidden = true,
                --         cwd = path,
                --         prompt_title = "Find Files - " .. path,
                --     })
                -- end,
                -- ["<leader>fs"] = function(state)
                --     local path = getPath(state)
                --     require("telescope.builtin").live_grep({
                --         cwd = path,
                --         prompt_title = "Live Grep - " .. path,
                --     })
                -- end,
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
