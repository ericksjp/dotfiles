--
-- ~/.config/nvim/lua/plugins/codecompanion.lua
--

-- This configuration is designed for a plugin manager like lazy.nvim.
-- It returns a Lua table that specifies the plugin to be loaded and its configuration.
return {
    -- The GitHub repository for the codecompanion.nvim plugin.
    "olimorris/codecompanion.nvim",
    enabled = true,
    -- Specifies other plugins that codecompanion.nvim needs to function correctly.
    dependencies = {
        -- plenary.nvim provides common utility functions that are used by many Neovim plugins.
        "nvim-lua/plenary.nvim",
        "ravitemer/codecompanion-history.nvim", -- history extension
    },
    -- The 'opts' table contains all the user-specific settings for the plugin.
    opts = {
        -- This 'strategies' table sets the DEFAULT AI PROVIDER and MODEL
        -- for different categories of actions within the plugin.
        strategies = {
            -- Configures the default model for running custom prompts.
            cmd = {
                adapter = "ollama",
                model = "qwen2.5-coder:3b",
            },
            -- Configures the model for the interactive chat window (:CompanionChat).
            chat = {
                adapter = "ollama",
                model = "qwen2.5-coder:3b",
            },
            -- Configures the model for any action that modifies code directly in your buffer
            -- using the 'inline' strategy.
            inline = {
                adapter = "ollama",
                model = "qwen2.5-coder:3b",
            },
        },
        extensions = {
            history = {
                enabled = true,
                opts = {
                    dir_to_save = vim.fn.stdpath("data") .. "/codecompanion_chats.json",
                },
            },
        },

        display = {
            chat = {
                -- Window options for the chat buffer
                window = {
                    buflisted = false, -- List the chat buffer in the buffer list?
                    sticky = false, -- Chat buffer remains open when switching tabs

                    layout = "float", -- float|vertical|horizontal|buffer
                    full_height = true, -- for vertical layout
                    position = nil, -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)

                    width = 0.7, ---@return number|fun(): number
                    height = 0.8, ---@return number|fun(): number
                    border = "single",
                    relative = "editor",

                    -- Ensure that long paragraphs of markdown are wrapped
                    opts = {
                        breakindent = true,
                        linebreak = true,
                        wrap = true,
                    },
                },
            },
        },

        intereactions = {
            chat = {
                keymaps = {
                    send = {
                        modes = { n = "<C-j>", i = "<C-j>" },
                        opts = {},
                    },
                },
            },
        },

        -- The 'prompt_library' is where you define your own reusable, custom AI commands.
        prompt_library = {
            -- The name of the custom prompt. Run with :CodeCompanionActions
            ["Boilerplate HTML"] = {
                strategy = "inline",
                description = "Generate some boilerplate HTML",
                prompts = {
                    {
                        role = "system",
                        content = "You are an expert HTML programmer",
                    },
                    {
                        role = "user",
                        content = "<user_prompt>Please generate some HTML boilerplate for me. Return the code only and no markdown codeblocks</user_prompt>",
                    },
                },
            },
            ["Generate Commit Message"] = {
                strategy = "chat",
                description = "Generate commit message based on git diff",
                prompts = {
                    {
                        role = "system",
                        content = "You are an expert software developer who writes clear, concise commit messages following conventional commit format. Analyze the git diff and generate an appropriate commit message.",
                    },
                    {
                        role = "user",
                        content = "<user_prompt>Here's the git diff:\n\n```diff\n"
                            .. vim.fn.system("git diff --cached")
                            .. "\n```\n\nPlease generate a commit message following this format:\n- type(scope): description\n- Keep it under 50 characters for the first line\n- Use types: feat, fix, docs, style, refactor, test, chore\n- Add a more detailed body if needed\n- Be specific about what changed and why\n\nProvide just the commit message without any additional text.</user_prompt>",
                    },
                },
            },
        },
    },
}
