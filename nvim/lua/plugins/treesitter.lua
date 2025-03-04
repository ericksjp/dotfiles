return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "javascript",
        "typescript",
        "tsx",
        "css",
        "gitignore",
        "graphql",
        "http",
        "json",
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
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
      indent = {
        enable = true,
      },
      highlight = {
        enable = true, -- Enable treesitter highlighting
        additional_vim_regex_highlighting = true,
      },
    },
  },
}
