return {
    "yetone/avante.nvim",
    enabled = false,
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
        instructions_file = "avante.md",
        provider = "ollama",
        providers = {
            copilot = {
                model = "claude-opus-4.5",
            },
            ollama = {
                model = "qwen2.5-coder:3b",
                endpoint = "http://127.0.0.1:11434",
                is_env_set = function()
                    return true
                end,
            },
        },
        -- auto_suggestions_provider = "copilot",
        -- behaviour = {
        --     enable_fastapply = true, -- Enable Fast Apply feature
        --     auto_suggestions = false, -- Experimental stage
        --     auto_set_keymaps = true,
        --     suggestion = {
        --         debounce = 75, -- how often requests run (ms)
        --         throttle = 600,
        --     },
        -- },
        mappings = {
            submit = {
                normal = "<C-j>",
                insert = "<C-j>",
            },
        },
        windows = {
            position = "left", -- the position of the sidebar
            width = 35,
            ask = {
                floating = true,
            },
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-mini/mini.pick", -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua", -- for file_selector provider fzf
        "stevearc/dressing.nvim", -- for input provider dressing
        "folke/snacks.nvim", -- for input provider snacks
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        -- "zbirenbaum/copilot.lua", -- for providers='copilot'
        -- {
        --     -- support for image pasting
        --     "HakonHarnes/img-clip.nvim",
        --     event = "VeryLazy",
        --     opts = {
        --         -- recommended settings
        --         default = {
        --             embed_image_as_base64 = false,
        --             prompt_for_file_name = false,
        --             drag_and_drop = {
        --                 insert_mode = true,
        --             },
        --             -- required for Windows users
        --             use_absolute_path = true,
        --         },
        --     },
        -- },
        -- {
        --     -- Make sure to set this up properly if you have lazy=true
        --     "MeanderingProgrammer/render-markdown.nvim",
        --     opts = {
        --         file_types = { "markdown", "Avante" },
        --     },
        --     ft = { "markdown", "Avante" },
        -- },
    },
}
