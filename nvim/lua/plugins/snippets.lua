return {
  "hrsh7th/nvim-cmp",
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
    local ls = require("utils.mysnips")
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

    opts.mapping = vim.tbl_extend("force", opts.mapping, {
      ["<C-space>"] = {},
      ["<C-d>"] = cmp.mapping.abort(),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm({ select = true })
        elseif vim.snippet.active({ direction = 1 }) then
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
        elseif ls.jumpable(1) then
          ls.jump(1)
        elseif require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").accept()
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

    opts.sources = vim.tbl_extend("force", opts.sources, {
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
    })

    opts.sorting = {
      comparators = {
        function(entry1, entry2)
          local kind1 = entry1:get_kind() == "text" and 100 or 0
          local kind2 = entry2:get_kind() == "text" and 100 or 0
          if kind1 ~= kind2 then
            return kind2 < kind1
          end
        end,
        function(entry1, entry2)
          local kind1 = entry1:get_kind()
          local kind2 = entry2:get_kind()

          if kind1 == "snippet" and kind2 ~= "snippet" then
            return true
          elseif kind2 == "snippet" and kind1 ~= "snippet" then
            return false
          end
        end,
        cmp.config.compare.exact,
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
