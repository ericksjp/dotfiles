return {
    name = "c build",
    builder = function()
        local file = vim.fn.fnameescape(vim.fn.expand("%:p"))
        local output = vim.fn.fnameescape(vim.fn.expand("%:p:r")) -- Use full path for output too

        return {
            cmd = {
                "/usr/bin/gcc",
                "-fdiagnostics-color=always",
                "-g",
                file,
                "-o",
                output,
            },

            components = {
                "on_exit_set_status",
                "on_complete_notify",
                { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
            },
        }
    end,
    condition = {
        filetype = { "c" },
    },
}
