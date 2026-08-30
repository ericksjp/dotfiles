return {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
        vim.g.nvim_surround_no_normal_mappings = true

        -- vim.keymap.set("n", "sa", "<Plug>(nvim-surround-normal)", {
        --     desc = "Add a surrounding pair around a motion (normal mode)",
        -- })
        -- vim.keymap.set("n", "sd", "<Plug>(nvim-surround-delete)", {
        --     desc = "Delete a surrounding pair",
        -- })
        -- vim.keymap.set("n", "sr", "<Plug>(nvim-surround-change)", {
        --     desc = "Change a surrounding pair",
        -- })
        --
        vim.keymap.set("x", "s", "<Plug>(nvim-surround-visual)", { noremap = false })
        vim.keymap.set("x", "S", "<Plug>(nvim-surround-visual-line)", { noremap = false })

        require("nvim-surround").setup({
            aliases = {
                ["q"] = "'",
                ["Q"] = '"',
            },
        })
    end,
}
