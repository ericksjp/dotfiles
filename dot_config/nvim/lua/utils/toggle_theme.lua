local uv = vim.uv

local M = {}

local opts = {
    filepath = vim.fn.stdpath("data") .. "/bgfile",
    light_theme = "dayfox",
    dark_theme = "vscode",
}

local function read_file(path)
    local file = io.open(path, "r")
    if not file then
        return "dark"
    end
    local content = file:read("*line")
    file:close()
    return content
end

local function watch_theme_change()
    local handle = uv.new_fs_event()

    local function unwatch_cb()
        if handle then
            uv.fs_event_stop(handle)
        end
    end

    local function event_cb(err)
        if err then
            error("Theme file watcher failed")
            unwatch_cb()
        else
            -- Important to wrap in schedule, otherwise error E5560
            vim.schedule(function()
                local theme = read_file(opts.filepath)
                if theme == "light" then
                    vim.api.nvim_set_option_value("background", "light", {})
                else
                    vim.api.nvim_set_option_value("background", "dark", {})
                end
                unwatch_cb()
                watch_theme_change()
            end)
        end
    end

    local flags = {
        watch_entry = false, -- true = when dir, watch dir inode, not dir content
        stat = false, -- true = don't use inotify/kqueue but periodic check, not implemented
        recursive = false, -- true = watch dirs inside dirs
    }

    -- attach handler
    if handle then
        uv.fs_event_start(handle, opts.filepath, flags, event_cb)
    end

    return handle
end

local function set_dark_mode()
    vim.cmd("colorscheme " .. opts.dark_theme)
    require("lualine").setup({
        options = {
            theme = {
                normal = { c = { fg = "#bbc2cf", bg = "#111111" } },
                inactive = { c = { fg = "#bbc2cf", bg = "#111111" } },
            },
        },
    })
end

local function set_light_mode()
    vim.cmd("colorscheme " .. opts.light_theme)
    require("lualine").setup({ options = { theme = "dayfox" } })
end

M.setup = function(received_opts)
    opts = vim.tbl_deep_extend("force", received_opts, opts)

    local theme = read_file(opts.filepath)
    if theme == "light" then
        set_light_mode()
    else
        set_dark_mode()
    end

    local augroup = vim.api.nvim_create_augroup("ThemeWatcher", { clear = true })

    vim.api.nvim_create_autocmd("OptionSet", {
        group = augroup,
        pattern = "background",
        callback = function()
            local opt = vim.api.nvim_get_option_value("background", {
                scope = "global",
            })
            if opt == "light" then
                set_light_mode()
            else
                set_dark_mode()
            end
        end,
    })

    watch_theme_change()
end

return M
