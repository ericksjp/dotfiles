local create_files = require("utils.ntree_helper").create_files

return {
    "stevearc/oil.nvim",
    enabled = true,
    config = function()
        local oil = require("oil")
        local refresh = require("oil.actions").refresh.callback
        local detail = true

        oil.setup({
            float = {
                padding = 2,
                max_width = 0.5,
                max_height = 0.5,
                get_win_title = function()
                    return oil.get_current_dir() .. " - " .. require("utils.smart").CurrentDir().name
                end,
                border = "rounded",
                win_options = {
                    winblend = 0,
                },
                preview_split = "below",
                override = function(conf)
                    return conf
                end,
            },
            columns = {
                "icon",
                "permissions",
                "size",
                "mtime",
            },
            lsp_file_methods = {
                enabled = true,
                timeout_ms = 1000,
                autosave_changes = true,
            },
            default_file_explorer = true,
            delete_to_trash = true,
            constrain_cursor = "name",
            skip_confirm_for_simple_edits = true,
            keymaps = {
                ["g?"] = { "actions.show_help", mode = "n" },
                -- ["q"] = { "actions.close", mode = "n" },
                ["<esc>"] = { "actions.close", mode = "n" },
                ["H"] = { "actions.toggle_hidden", mode = "n" },
                ["e"] = { "actions.parent", mode = "n" },
                ["m"] = "actions.select",
                ["<CR>"] = "actions.select",
                -- ["<localleader>l"] = { "actions.select", opts = { vertical = true } },
                ["<localleader>j"] = { "actions.select", opts = { horizontal = true } },
                ["<localleader>t"] = { "actions.select", opts = { tab = true } },
                ["<localleader>r"] = "actions.refresh",
                ["<localleader>p"] = "actions.preview",
                ["g\\"] = { "actions.toggle_trash", mode = "n" },
                ["<localleader>,"] = { "actions.cd", mode = "n" },
                ["<localleader>c"] = { "actions.open_cwd", mode = "n" },
                -- ["<localleader>o"] = { "actions.change_sort", mode = "n" },
                ["<localleader>e"] = "actions.open_external",
                ["<localleader>g"] = { "actions.toggle_trash", mode = "n" },
                ["<localleader>y"] = { "actions.yank_entry", mode = "n" },
                ["<localleader>k"] = {
                    desc = "Toggle file and details",
                    callback = function()
                        detail = not detail
                        if detail then
                            oil.set_columns({ "icon", "permissions", "size", "mtime" })
                        else
                            oil.set_columns({ "icon" })
                        end
                    end,
                },
                ["<localleader>d"] = {
                    desc = "Set Pined Directory",
                    callback = function()
                        require("utils.pined").set_pined(oil.get_current_dir())
                        -- if entry.type == "directory" then
                        --     local path = oil.get_current_dir() .. entry.name
                        --     require("utils.pined").set_pined(path)
                        -- end
                    end,
                },
                ["<Tab>"] = {
                    desc = "Move to Another Directory",
                    callback = function()
                        require("utils.smart").Oil(true)
                    end,
                },
                ["ç"] = {
                    "actions.open_cmdline",
                    opts = {
                        shorten_path = true,
                        modify = ":h",
                    },
                    desc = "Open the command line with the current directory as an argument",
                },
                ["<leader>a"] = {
                    desc = "Batch Create Files",
                    callback = function()
                        local base_path = oil.get_current_dir()
                        local input = vim.fn.input("Create: ")

                        local ok = pcall(create_files, base_path, input)

                        if ok then
                            refresh()
                        end
                    end,
                },
                ["<localleader>o"] = {
                    desc = "Add to opencode context",
                    callback = function()
                        local entry = oil.get_cursor_entry()
                        local path = oil.get_current_dir() .. entry.name
                        require("opencode.context").add_file(path)
                    end,
                },
                ["ss"] = {
                    desc = "Open file in split to the right",
                    callback = function()
                        -- Pega a entrada atual sob o cursor
                        local entry = require("oil").get_cursor_entry()
                        if not entry then
                            return
                        end

                        -- Se for um diretório, o comportamento padrão de abrir a pasta continua
                        if entry.type == "directory" then
                            oil.select()
                            return
                        end

                        local oil_win = vim.api.nvim_get_current_win()

                        local current_dir = oil.get_current_dir()
                            or vim.b.oil_original_dir
                            or vim.fn.expand("%:p:h") .. "/"

                        if not current_dir or current_dir == "" then
                            vim.notify("Error: fuck you", vim.log.levels.ERROR)
                            return
                        end

                        local full_path = current_dir .. entry.name

                        vim.cmd("wincmd l")
                        local target_win = vim.api.nvim_get_current_win()

                        -- Se ainda estivermos na mesma janela (não havia janela à direita)
                        if target_win == oil_win then
                            vim.cmd("vsplit")

                            local columns = vim.o.columns
                            vim.cmd("vertical resize " .. math.floor(columns * 0.7))
                        end

                        vim.cmd("edit " .. vim.fn.fnameescape(full_path))
                    end,
                },
                ["<localleader>f"] = {
                    desc = "Open file explorer in current dir",
                    callback = function()
                        local dir = oil.get_current_dir()

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
                },

                -- ["<C-s>"] = {
                --   desc = "Save changes",
                --   callback = function()
                --     require("oil").save(nil, function(err)
                --       if err then
                --         print("Error: " .. err)
                --       end
                --       require("oil").close()
                --     end)
                --   end,
                -- },
            },
            use_default_keymaps = false,
        })
    end,
}
