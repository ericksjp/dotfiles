local IS_DEV = false

local prompts = {
    -- Code related prompts
    Explain = "Please explain how the following code works.",
    Review = "Please review the following code and provide suggestions for improvement.",
    Tests = "Please explain how the selected code works, then generate unit tests for it.",
    Refactor = "Please refactor the following code to improve its clarity and readability.",
    FixCode = "Please fix the following code to make it work as intended.",
    FixError = "Please explain the error in the following text and provide a solution.",
    BetterNamings = "Please provide better names for the following variables and functions.",
    Documentation = "Please provide documentation for the following code.",
    SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
    SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
    -- Text related prompts
    Summarize = "Please summarize the following text.",
    Spelling = "Please correct any grammar and spelling errors in the following text.",
    Wording = "Please improve the grammar and wording of the following text.",
    Concise = "Please rewrite the following text to make it more concise.",
    Commit = "Please create a commit message for these changes.",
    Translate = "Please translate this to pt-BR."
}

return {
    dir = IS_DEV and "~/Projects/research/CopilotChat.nvim" or nil,
    "CopilotC-Nvim/CopilotChat.nvim",
    event = "VeryLazy",
    version = "v2.10.0",
    -- branch = "canary", -- Use the canary branch if you want to test the latest features but it might be unstable
    -- Do not use branch and version together, either use branch or version
    dependencies = {
        { "nvim-telescope/telescope.nvim" }, -- Use telescope for help actions
        { "nvim-lua/plenary.nvim" },
    },
    opts = {
        question_header = "## User ",
        answer_header = "## Copilot ",
        error_header = "## Error ",
        prompts = prompts,
        auto_follow_cursor = false, -- Don't follow the cursor after getting response
        show_help = false, -- Show help in virtual text, set to true if that's 1st time using Copilot Chat
        -- default selection (visual or line)
        selection = function(source)
            local select = require("CopilotChat.select")
            return select.visual(source) or select.buffer(source)
        end,
        mappings = {
            -- Use tab for completion
            complete = {
                detail = "Use @<Tab> or /<Tab> for options.",
                insert = "<Tab>",
            },
            -- Close the chat
            close = {
                normal = "q",
                insert = "<C-c>",
            },
            -- Reset the chat buffer
            reset = {
                normal = "<C-l>",
                insert = "<C-l>",
            },
            -- Submit the prompt to Copilot
            submit_prompt = {
                normal = "<C-j>",
                insert = "<C-j>",
            },
            -- Accept the diff
            accept_diff = {
                normal = "<C-y>",
                insert = "<C-y>",
            },
            -- Yank the diff in the response to register
            yank_diff = {
                normal = "gmy",
            },
            -- Show the diff
            show_diff = {
                normal = "gmd",
            },
            -- Show the prompt
            show_system_prompt = {
                normal = "gmp",
            },
            -- Show the user selection
            show_user_selection = {
                normal = "gms",
            },
        },
    },
    config = function(_, opts)
        local chat = require("CopilotChat")
        local select = require("CopilotChat.select")

        opts.auto_insert_mode = true

        -- Override the git prompts message
        opts.prompts.Commit = {
            prompt = "Write commit message for the change with commitizen convention",
            selection = select.gitdiff,
        }
        opts.prompts.CommitStaged = {
            prompt = "Write commit message for the change with commitizen convention",
            selection = function(source)
                return select.gitdiff(source, true)
            end,
        }

        chat.setup(opts)

        vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
            chat.ask(args.args, { selection = select.visual })
        end, { nargs = "*", range = true })

        -- Inline chat with Copilot
        vim.api.nvim_create_user_command("CopilotChatInline", function(args)
            chat.ask(args.args, {
                selection = select.visual,
                window = {
                    layout = "float",
                    relative = "editor",
                    width = 0.8,
                    height = 0.8,
                    winblend = 0, -- Set the transparency to 50%
                    -- row = 1,
                },
            })
        end, { nargs = "*", range = true })

        -- Restore CopilotChatBuffer
        vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
            chat.ask(args.args, { selection = select.buffer })
        end, { nargs = "*", range = true })

        -- Custom buffer for CopilotChat
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "copilot-*",
            callback = function()
                vim.opt_local.relativenumber = false
                vim.opt_local.number = false

                -- Get current filetype and set it to markdown if the current filetype is copilot-chat
                local ft = vim.bo.filetype
                if ft == "copilot-chat" then
                    vim.bo.filetype = "markdown"
                end
            end,
        })
    end,
}
