return {
    "stevearc/overseer.nvim",
    ---@module 'overseer'
    ---@type overseer.SetupOpts
    opts = {},
    lazy = true,
    config = function()
        require("overseer").setup({
            dap = false,
        })
    end
}
