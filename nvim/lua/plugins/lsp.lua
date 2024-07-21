---@diagnostic disable: missing-fields
return {
  -- tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "luacheck",
        "shellcheck",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
        "jdtls",
        -- "clangd",
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
        -- clangd = {},
        jdtls = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern("pom.xml", ".git")(...)
          end,
          -- handlers = {
          -- 	["$/progress"] = function() end,
          -- },
        },
        cssls = {},
        tailwindcss = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
        },
        -- tsserver = {},
        -- html = {},
        lua_ls = {},
      },
    },
  },
}
