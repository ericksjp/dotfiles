return {
    name = "run script",
    builder = function()
        local file = vim.fn.expand("%:p")
        local cmd = file

        if vim.bo.filetype == "go" then
            cmd = string.format("go run %s", file)
        elseif vim.bo.filetype == "python" then
            cmd = string.format("python %s", file)
        elseif vim.bo.filetype == "c" then
            local output = vim.fn.expand("%:p:r")
            cmd = string.format("gcc %s -o %s && %s", file, output, output)
        elseif vim.bo.filetype == "sh" then
            cmd = string.format("bash %s", file)
        end

        return {
            cmd = cmd,
            shell = true,
            components = {
                { "on_output_quickfix", set_diagnostics = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    condition = {
        filetype = { "sh", "python", "go", "c" },
    },
}
