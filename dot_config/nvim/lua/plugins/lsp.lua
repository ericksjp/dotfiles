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
                "xmlformatter",
                "lemminx",
                "google-java-format",
                "palantir-java-format",
            })
        end,
    },

    -- code formatters
    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
            opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft, {
                xml = { "xmlformatter" },
                java = { "palantir-java-format" },
            })

            -- opts.formatters = vim.tbl_extend("force", opts.formatters or {}, {
            --     prettierd = {
            --         prepend_args = { "--tab-width", "4" },
            --     },
            --     -- It's a good idea to configure standard prettier too, just in case
            --     prettier = {
            --         prepend_args = { "--tab-width", "4" },
            --     },
            -- })

            -- opts.formatters = vim.tbl_extend("force", opts.formatters, {
            --     prettier = {
            --         prepend_args = { "--tab-width", "2", "--print-width", "120" },
            --     },
            -- })

            return opts
        end,
    },

    -- -- linters
    -- {
    --     "mfussenegger/nvim-lint",
    --     optional = true,
    --     opts = function(_, opts)
    --         for _, ft in ipairs(sql_ft) do
    --             opts.linters_by_ft[ft] = opts.linters_by_ft[ft] or {}
    --             table.insert(opts.linters_by_ft[ft], "sonarlint-language-server")
    --         end
    --     end,
    -- },

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
