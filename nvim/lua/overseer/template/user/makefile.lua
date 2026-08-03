return {
    name = "Make Build Debug",
    builder = function()
        return {
            cmd = { "make" },
            args = { "debug" },
            components = {
                "on_exit_set_status",
                "on_complete_notify",
                { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
            },
        }
    end,
    condition = {
        callback = function()
            return vim.loop.fs_stat("Makefile") ~= nil
        end,
    },
}
