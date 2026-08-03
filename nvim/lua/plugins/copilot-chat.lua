-- init.lua or plugins.lua
return {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    build = "make tiktoken", -- optional but recommended
    opts = {
        -- Default model to use
        model = "qwen2.5-coder:3b",

        -- Custom providers
        providers = {
            ollama = {
                api_base = "http://localhost:11434", -- Ollama endpoint
                api_key = "", -- empty key is fine
            },
        },

        -- Default provider for CopilotChat
        provider = "ollama", -- use the “ollama” provider
    },
}
