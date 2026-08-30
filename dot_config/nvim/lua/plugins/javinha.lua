return {
    'ericksjp/java.nvim',
    enabled = true,
    config = function()
        require("java").setup({
            rename = {
                write_and_close = true,
            }
        })
    end
}
