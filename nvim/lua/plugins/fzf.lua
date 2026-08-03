return {
    "ibhagwan/fzf-lua",
    opts = function(_, opts)
        local fzf = require("fzf-lua")
        local smart = require("utils.smart")
        local config = fzf.config
        local futils = require("utils.fzf-util")

        local function next(_, ctx)
            local o = vim.deepcopy(ctx.__call_opts)

            local current = smart.GetCurrent(true)
            o.cwd = current.getDir()
            o.winopts = {
                title = "Files-" .. current.name,
            }

            o.buf = ctx.__CTX.bufnr
            LazyVim.pick.open(ctx.__INFO.cmd, o)
        end

        config.defaults.keymap.builtin["<C-e>"] = "toggle-preview"

        config.defaults.actions.grep = { ["tab"] = next }
        config.defaults.actions.grep["alt-c"] = config.defaults.actions.grep["tab"]
        config.set_action_helpstr(config.defaults.actions.grep["tab"], "toggle-root-dir")

        config.defaults.actions.files["tab"] = next
        config.defaults.actions.files["alt-c"] = config.defaults.actions.files["tab"]
        config.set_action_helpstr(config.defaults.actions.files["tab"], "toggle-root-dir")

        opts.winopts = {
            height = 0.85,
            width = 0.8,
            row = 0.5,
            col = 0.5,

            border = "rounded",
            backdrop = 60,
            fullscreen = false,

            preview = {
                border = "border",
                layout = "vertical",
                flip_columns = 120,
                scrollbar = "float",
                hidden = "hidden",
            },
        }

        local actions = {
            ["ctrl-a"] = { fn = futils.track_selection, exec_silent = true, prefix = "toggle+down" },
            ["ctrl-q"]    = { fn = futils.fixed_qlist, prefix = "select-all" },
        }

        opts.grep.actions = vim.tbl_extend("force", opts.grep.actions, actions)
        opts.files.actions = vim.tbl_extend("force", opts.files.actions, actions)

        opts.files.cwd_prompt = true
        -- opts.grep.cwd_prompt = true
        opts.defaults.formatter = "path.dirname_first"
    end,
}
