return {
    "hrsh7th/nvim-cmp",
    enabled = true,
    dependencies = {
        { "saadparwaiz1/cmp_luasnip" },
        { "rafamadriz/friendly-snippets" },
        {
            "L3MON4D3/LuaSnip",
            lazy = true,
            build = "make install_jsregexp",
            opts = {
                history = true,
                delete_check_events = "TextChanged",
            },
        },
    },
    opts = function(_, opts)
        local cmp = require("cmp")
        local ls = require("utils.snippets")
        require("luasnip").filetype_extend("typescript", { "javascript" })
        -- require("luasnip").filetype_extend("vimwiki", { "markdown" })
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.event:on("menu_opened", function()
            vim.b.copilot_suggestion_hidden = true
        end)

        cmp.event:on("menu_closed", function()
            vim.b.copilot_suggestion_hidden = false
        end)

        opts.window = {
            completion = cmp.config.window.bordered(),
            documentation = false,
        }

        local symbol_map = {
            Text = "󰉿",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "",
            Field = "󰜢",
            Variable = "󰀫",
            Class = "󰠱",
            Interface = "",
            Module = "",
            Property = "󰜢",
            Unit = "󰑭",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "󰏘",
            File = "󰈙",
            Reference = "󰈇",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰏿",
            Struct = "󰙅",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "",
        }

        local ELLIPSIS_CHAR = "…"
        local MAX_LABEL_WIDTH = 30
        local MIN_LABEL_WIDTH = 30

        opts.formatting = {
            format = function(entry, vim_item)
                local label = (symbol_map[vim_item.kind] or "") .. " " .. vim_item.abbr
                local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
                if truncated_label ~= label then
                    vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
                elseif string.len(label) < MIN_LABEL_WIDTH then
                    local padding = string.rep(" ", MIN_LABEL_WIDTH - string.len(label))
                    vim_item.abbr = label .. padding
                end

                local detail = entry.completion_item.labelDetails and entry.completion_item.labelDetails.description
                if detail then
                    local truncated_detail = vim.fn.strcharpart(detail, 0, MAX_LABEL_WIDTH - 3)
                    if truncated_detail ~= detail then
                        vim_item.menu = truncated_detail .. ELLIPSIS_CHAR
                    else
                        vim_item.menu = string.rep(" ", MIN_LABEL_WIDTH - string.len(detail)) .. detail
                    end
                else
                    vim_item.menu = string.rep(" ", MIN_LABEL_WIDTH)
                end

                vim_item.kind = ""

                return vim_item
            end,
        }

        opts.snippet = {
            expand = function(args)
                ls.lsp_expand(args.body)
            end,
        }

        opts.matching = {
            disallow_fuzzy_matching = true,
            disallow_fullfuzzy_matching = true,
            disallow_partial_fuzzy_matching = true,
            disallow_partial_matching = true,
            disallow_prefix_unmatching = true,
            disallow_symbol_nonprefix_matching = true,
        }

        opts.experimental = {
            ghost_text = false,
        }

        opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
            ["<C-d>"] = cmp.mapping.abort(),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.confirm({ select = true })
                elseif require("copilot.suggestion").is_visible() then
                    require("copilot.suggestion").accept()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-Space>"] = cmp.mapping(function(fallback)
                if vim.snippet.active({ direction = 1 }) then
                    vim.schedule(function()
                        vim.snippet.jump(1)
                    end)
                elseif ls.jumpable(1) then
                    ls.jump(1)
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-e>"] = cmp.mapping(function(fallback)
                if vim.snippet.active({ direction = -1 }) then
                    vim.schedule(function()
                        vim.snippet.jump(-1)
                    end)
                elseif ls.jumpable(-1) then
                    ls.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-F>"] = function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<right>", true, true, true), "n", true)
            end,
            ["<C-B>"] = function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<left>", true, true, true), "n", true)
            end,
        })

        opts.sources = {
            {
                name = "nvim_lsp",
                entry_filter = function(entry, _)
                    if entry.source.source.client.name == "emmet_language_server" then
                        return true
                    end
                    if entry:get_kind() == 15 then
                        return false
                    end
                    return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
                end,
            },
            {
                name = "buffer",
                entry_filter = function(entry, _)
                    if entry:get_kind() == 15 then
                        return false
                    end
                    return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
                end,
            },
            { name = "luasnip" },
            { name = "path" },
        }

        local function deprio(kind)
            return function(e1, e2)
                if e1:get_kind() == kind then
                    return false
                end
                if e2:get_kind() == kind then
                    return true
                end
            end
        end

        local function prio(kind)
            return function(e1, e2)
                if e1:get_kind() == kind and e2:get_kind() ~= kind then
                    return true
                end
                if e2:get_kind() == kind and e1:get_kind() ~= kind then
                    return false
                end
            end
        end

        opts.sorting = {
            comparators = {
                cmp.config.compare.exact,
                prio(cmp.lsp.CompletionItemKind.Keyword),
                prio(cmp.lsp.CompletionItemKind.Snippet),
                deprio(cmp.lsp.CompletionItemKind.Text),
                cmp.config.compare.offset,
                cmp.config.compare.kind,
                cmp.config.compare.score,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
            },
        }
    end,
}
