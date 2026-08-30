return {
    {
        "sainnhe/sonokai",
        lazy = true,
        config = function()
            vim.cmd([[
                let g:sonokai_style = 'default'
                let g:sonokai_background = 'soft'
                " For better performance
                let g:sonokai_better_performance = 1
                let g:sonokai_transparent_background = 0
                let g:sonokai_float_style = 'dim'
                " let g:sonokai_colors_override = {'bg1': ['#171717', '100']}
            ]])
        end,
    },
    {
        "sainnhe/edge",
        lazy = true,
        config = function()
            vim.cmd([[
                let g:edge_style = 'light'
                " let g:sonokai_background = 'soft'
                " " For better performance
                " let g:sonokai_better_performance = 1
                " let g:sonokai_transparent_background = 2
                " let g:sonokai_float_style = 'dim'
                " let g:sonokai_colors_override = {'bg1': ['#171717', '100']}
            ]])
        end,
    },
    {
        "nickkadutskyi/jb.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            -- set this in init.lua
            -- vim.api.nvim_set_hl(0, "javaExceptions", { link = "Keyword", underline = false })

            require("jb").setup({
                transparent = false,
                snacks = {
                    explorer = {
                        enabled = true,
                    },
                },
            })
            -- vim.cmd("colorscheme jb")
        end,
    },
    {
        "EdenEast/nightfox.nvim",
        priority = 1001,
        lazy = false,
        config = function()
            require("nightfox").setup({
                options = {
                    transparent = false,
                },
                palette = {
                    all = {
                        sel0 = "#ff0000",
                        sel1 = "#ff0000",
                    },
                },

                groups = {
                    all = {
                        CursorLine = { fg = "none", bg = "none" },
                        NeoTreeCursorLine = { fg = "none", bg = "#d3c6b8" },
                        -- FzfCursorLine = { fg = "none", bg = "#d3c6b8" },
                        FzfLuaCursorLine = { fg = "none", bg = "#d3c6b8" },
                        -- TelescopeSelection = { fg = "none", bg = "#d3c6b8" },
                        -- TelescopeNormal = { fg = "#393b44", bg = "none" },
                    },
                },
            })
        end,
    },
    {
        "Mofiqul/vscode.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            require("vscode").setup({
                style = "dark",
                transparent = false,
                italic_comments = true,
                underline_links = true,
                -- color_overrides = {
                --     vscCursorDarkDark = "#111111",
                -- },

                group_overrides = {
                    CursorLine = { fg = "none", bg = "none", bold = false },
                },
            })
        end,
    },
}
