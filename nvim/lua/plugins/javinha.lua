return {
    'simaxme/java.nvim',
    config = function()
        require("java").setup({
            rename = {
                write_and_close = true,
            }
        })
    end
}
