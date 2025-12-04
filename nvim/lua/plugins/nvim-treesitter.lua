return {
  "nvim-treesitter/nvim-treesitter",
  lazy = true,
  -- build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "javascript",
      "typescript",
      "tsx",
      "css",
      "gitignore",
      "graphql",
      "http",
      "scss",
      "sql",
      "vim",
      "lua",
      "c",
      "cpp",
      "bash",
      "java",
      "prisma",
      "vimdoc",
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = true,
    },
    indent = {
      enable = true,
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },
  }
}
