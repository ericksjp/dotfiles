---@diagnostic disable: missing-fields
return {

  {
    "williamboman/mason.nvim",
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
      })
    end,
  },

  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("lsp-file-operations").setup()
      local lspconfig = require("lspconfig")

      lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        capabilities = vim.tbl_deep_extend(
          "force",
          vim.lsp.protocol.make_client_capabilities(),
          require("lsp-file-operations").default_capabilities()
        ),
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
