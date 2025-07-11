return {
    {
        'nanozuki/tabby.nvim',
        config = function()
            local theme = {
                current = { fg = "#cad3f5", bg = "none", style = "bold" },
                not_current = { fg = "#5b6078", bg = "none" },

                fill = { bg = "none" },
            }

            require('tabby').setup({
                line = function (line)
                    return {
                        line.tabs().foreach(function(tab)
                        local hl = tab.is_current() and theme.current or theme.not_current
                        return {
                            line.sep(" ", hl, theme.fill),
                            tab.name(),
                            line.sep(" ", hl, theme.fill),
                            hl = hl,
                        }
                        end),
                        }
                end
            })
        end,
    },
    {
        "romgrk/barbar.nvim",
        enabled = false,
        dependencies = { "ThePrimeagen/harpoon" },
        config = function()
            local barbar = require("barbar")
            local state = require("barbar.state")
            local render = require("barbar.ui.render")
            local harpoon = require("harpoon")

            barbar.setup({
                auto_hide = 1,
                hide = {
                    inactive = true,
                },
                icons = {
                    pinned = { filename = true, buffer_index = true },
                    diagnostics = { { enabled = true } },
                },
            })

            local function unpin_all()
                for _, buf in ipairs(state.buffers) do
                    local data = state.get_buffer_data(buf)
                    data.pinned = false
                end
            end

            local function get_buffer_by_mark(mark)
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    local buffer_path = vim.api.nvim_buf_get_name(buf)

                    if buffer_path == "" or mark.value == "" then
                        goto continue
                    end

                    local mark_pattern = mark.value:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
                    if string.match(buffer_path, mark_pattern) then
                        return buf
                    end

                    local buffer_path_pattern = buffer_path:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
                    if string.match(mark.value, buffer_path_pattern) then
                        return buf
                    end

                    ::continue::
                end
            end

            local function refresh_all_harpoon_tabs()
                local list = harpoon:list()
                unpin_all()
                for _, mark in ipairs(list.items) do
                    local buf = get_buffer_by_mark(mark)
                    if buf == nil then
                        vim.cmd("badd " .. mark.value)
                        buf = get_buffer_by_mark(mark)
                    end
                    if buf ~= nil then
                        state.toggle_pin(buf)
                    end
                end
                render.update()
            end

            vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufLeave", "User" }, {
                callback = refresh_all_harpoon_tabs,
            })
        end,
    }
}
