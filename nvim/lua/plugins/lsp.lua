---@diagnostic disable: missing-fields
return {
    {
        "mason-org/mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, {
                "luacheck",
                "shellcheck",
                "shfmt",
                -- "tailwindcss-language-server",
                -- "typescript-language-server",
                "css-lsp",
                "emmet-language-server",
                "jdtls",
                "clangd",
                "eslint-lsp",
                "prettierd",
                "tailwindcss-language-server",
                "typescript-language-server",
            })
        end,
    },

    -- lsp servers
    {
        "neovim/nvim-lspconfig",
        opts = {
            inlay_hints = { enabled = false },
            ---@type lspconfig.options
            servers = {
                clangd = {
                    cmd = {
                        "clangd",
                        "--fallback-style=webkit",
                    },
                },

                lua_ls = {
                    settings = {},
                    Lua = {
                        format = {
                            enable = true,
                            defaultConfig = {
                                indent_style = "space",
                                indent_size = "4",
                            },
                            diagnostics = {
                                enable = true,
                            },
                            format = {
                                defaultConfig = {
                                    indent_style = "spaces",
                                    indent_size = "2",
                                },
                            },
                        },
                    },
                },

                prismals = {},
                emmet_language_server = {
                    filetypes = {
                        -- "css",
                        "eruby",
                        "html",
                        -- "javascript",
                        "javascriptreact",
                        "less",
                        "sass",
                        "scss",
                        "pug",
                        "typescriptreact",
                    },
                    init_options = {
                        includeLanguages = {},
                        excludeLanguages = {},
                        extensionsPath = {},
                        preferences = {},
                        showAbbreviationSuggestions = true,
                        showExpandedAbbreviation = "always",
                        showSuggestionsAsSnippets = false,
                        syntaxProfiles = {},
                        variables = {
                            item = "$",
                        },
                    },
                },
                tailwindcss = {
                    root_dir = function(...)
                        return require("lspconfig.util").root_pattern(".git")(...)
                    end,
                },
                vtsls = {
                    settings = {
                        -- typescript = {
                        --   tsdk = "/home/erick/.cache/typescript/5.5",
                        -- },
                        autoUseWorkspaceTsdk = true,
                    },

                    -- handlers = {
                    --   ["textDocument/publishDiagnostics"] = vim.lsp.with(function(_, params, ctx, config)
                    --     local new = {
                    --       diagnostics = {},
                    --       uri = params.uri,
                    --     }
                    --     for _, diagnostic in ipairs(params.diagnostics) do
                    --       if diagnostic.severity ~= 4 then
                    --         table.insert(new.diagnostics, diagnostic)
                    --       end
                    --     end
                    --     vim.lsp.diagnostic.on_publish_diagnostics(_, new, ctx, config)
                    --   end, {}),
                    -- },
                },
            },
        },
    },
}
