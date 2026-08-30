return {
    "mistweaverco/kulala.nvim",
    enabled = true,
    lazy = true,
    -- keys = {
    -- { "<leader>Rs", desc = "Send request" },
    --     { "<leader>Ra", desc = "Send all requests" },
    --     { "<leader>Rb", desc = "Open scratchpad" },
    -- },
    ft = {"http", "rest"},
    opts = {
        global_keymaps = true,
        global_keymaps_prefix = "<leader>k",
        kulala_keymaps_prefix = "",
        ui = {
            display_mode = "float",
            split_direction = "horizontal",
        }
    }
}
