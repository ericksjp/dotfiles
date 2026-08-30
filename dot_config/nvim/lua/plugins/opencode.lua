return {
    "NickvanDyke/opencode.nvim",
    enabled = true,
    -- dependencies = {
    --     -- Recommended for `ask()` and `select()`.
    --     -- Required for `snacks` provider.
    --     ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
    --     { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    -- },
    config = function()
        vim.g.opencode_opts = {

            server = {
                start = function()
                    vim.fn.jobstart({ "tmux", "split-window", "-dh", "-p", "35", "opencode --port" })
                end,
                toggle = function()
                    local cmd = [[
                    PANE_ID=$(tmux list-panes -F "#{pane_id} #{pane_current_command}" | grep "opencode" | awk '{print $1}')

                    if [ -n "$PANE_ID" ]; then
                        tmux break-pane -d -s "$PANE_ID" -n "opencode_hidden"
                    else
                        tmux join-pane -h -l 35% -s "opencode_hidden" 2>/dev/null || \
                        tmux split-window -dh -p 35 'opencode --port'
                    fi
                    ]]
                    vim.fn.jobstart({ "sh", "-c", cmd })
                end,
                stop = function()
                    vim.fn.jobstart({
                        "sh",
                        "-c",
                        "tmux list-panes -a -F '#{pane_id} #{pane_current_command}' | grep 'opencode' | awk '{print $1}' | xargs -I {} tmux kill-pane -t {}",
                    })
                end,
            },
        }

        -- Configurações obrigatórias e recomendadas
        vim.o.autoread = true

        vim.keymap.set({ "n" }, "<leader>oi", function()
            require("opencode").start()
        end, { desc = "Init opencode server" })

        vim.keymap.set({ "n" }, "<leader>ox", function()
            require("opencode").stop()
        end, { desc = "Init opencode server" })

        vim.keymap.set({ "n", "t" }, "<C-o>", function()
            require("opencode").toggle()
        end, { desc = "Toggle opencode" })

        vim.keymap.set({ "n" }, "<leader>oa", function()
            require("opencode").ask("@buffer: ", { submit = true })
        end, { desc = "Ask opencode…" })

        vim.keymap.set({ "x" }, "<leader>oa", function()
            require("opencode").ask("@this: ", { submit = true })
        end, { desc = "Ask opencode…" })

        vim.keymap.set({ "n", "x" }, "<leader>oe", function()
            require("opencode").select()
        end, { desc = "Execute opencode action…" })

        vim.keymap.set("v", "go", function()
            return require("opencode").operator("@this ")
        end, { desc = "Add range to opencode", expr = true })

        vim.keymap.set("n", "go", function()
            return require("opencode").operator("@buffer ") .. "_"
        end, { desc = "Add line to opencode", expr = true })

    end,
}
