return {
    -- {
    --     "github/copilot.vim",
    --     lazy = false, -- make sure the plugin *actually loads*
    --     event = "InsertEnter", -- optional lazy trigger
    --     enabled = true,
    -- },
    {

        "zbirenbaum/copilot.lua",
        dependencies = {
            "copilotlsp-nvim/copilot-lsp",
            init = function()
                -- vim.g.copilot_nes_debounce = 75
                -- vim.lsp.enable("copilot_ls")
                -- vim.keymap.set("n", "<leader>p", function()
                --     local bufnr = vim.api.nvim_get_current_buf()
                --     local state = vim.b[bufnr].nes_state
                --     if state then
                --         -- Try to jump to the start of the suggestion edit.
                --         -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
                --         local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
                --             or (
                --                 require("copilot-lsp.nes").apply_pending_nes()
                --                 and require("copilot-lsp.nes").walk_cursor_end_edit()
                --             )
                --         return nil
                --     else
                --         -- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
                --         return "<C-i>"
                --     end
                -- end)
            end,
        },
        cmd = "Copilot",
        event = "InsertEnter",
        -- lazy = true,
        enabled = true,
        build = ":Copilot auth",
        config = function()
            require("copilot").setup({
                panel = {
                    enabled = false,
                },
                suggestion = {
                    auto_trigger = true,
                    hide_during_completion = true,
                    trigger_on_accept = true,
                    debounce = 50,
                    keymap = {
                        accept_word = false,
                        accept_line = false,
                        -- accept = "<Tab>",
                        dismiss = "<C-d>",
                        suggest = "<C-,>",
                        next = "<C-l>",
                    },
                },
                -- nes = {
                --     enabled = true, -- requires copilot-lsp as a dependency
                --     auto_trigger = true,
                --     keymap = {
                --         accept_and_goto = "<c-f>",
                --         accept = false,
                --         dismiss = "<Esc>",
                --     },
                -- },
                auth_provider_url = nil, -- URL to authentication provider, if not "https://github.com/"
                logger = {
                    file = vim.fn.stdpath("log") .. "/copilot-lua.log",
                    file_log_level = vim.log.levels.OFF,
                    print_log_level = vim.log.levels.WARN,
                    trace_lsp = "off", -- "off" | "messages" | "verbose"
                    trace_lsp_progress = false,
                    log_lsp_messages = false,
                },
                copilot_node_command = "node", -- Node.js version must be > 22
                workspace_folders = {},
                copilot_model = "",
                disable_limit_reached_message = false, -- Set to `true` to suppress completion limit reached popup
                root_dir = function()
                    return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
                end,
                should_attach = function(_, _)
                    if not vim.bo.buflisted then
                        -- logger.debug("not attaching, buffer is not 'buflisted'")
                        return false
                    end

                    if vim.bo.buftype ~= "" then
                        -- logger.debug("not attaching, buffer 'buftype' is " .. vim.bo.buftype)
                        return false
                    end

                    return true
                end,
                server = {
                    type = "nodejs", -- "nodejs" | "binary"
                    custom_server_filepath = nil,
                },
                -- server_opts_overrides = {
                --     -- NES often requires specific settings passed to the LSP server
                --     settings = {
                --         advanced = {
                --             nextEditSuggestions = true,
                --         },
                --     },
                -- },
            })
        end,
    },
}
