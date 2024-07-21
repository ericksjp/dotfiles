return {
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          visual = "s",
          visual_line = "gs",
        },
        aliases = {
          ["q"] = "'",
          ["Q"] = '"',
        },
      })
    end,
  },
  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      "smoka7/hydra.nvim",
    },
    opts = {},
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    keys = {
      {
        mode = { "v", "n" },
        "<Leader>n",
        "<cmd>MCstart<cr>",
        desc = "Create a selection for selected text or word under the cursor",
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.completion = {
        autocomplete = false,
      }

      opts.formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, vim_item)
          local source = entry.source.name
          if source == "nvim_lsp" then
            vim_item.menu = "(lsp)"
          elseif source == "luasnip" then
            vim_item.menu = "(lsnip)"
          else
            vim_item.menu = "(" .. source .. ")"
          end
          return vim_item
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

      opts.window = {
        completion = cmp.config.window.bordered(),
        documentation = false,
      }

      opts.experimental = {
        ghost_text = false,
      }

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-d>"] = cmp.mapping.abort(),
        ["<C-j>"] = cmp.mapping.confirm({ select = true }),
      })
      opts.sources = vim.tbl_extend("force", opts.sources, {
        {
          name = "nvim_lsp",
          entry_filter = function(entry, _)
            if entry:get_kind() == 15 then
              return false
            end
            return true
          end,
        },
        {
          name = "buffer",
          entry_filter = function(entry, _)
            return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
          end,
        },
        { name = "path" },
      })
      -- Enable sorting similar to IntelliJ IDEA
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
          cmp.config.compare.offset,
          cmp.config.compare.kind,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      }
    end,
  },
}
