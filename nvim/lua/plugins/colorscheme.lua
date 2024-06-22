return {
  {
    "catppuccin/nvim",
    enabled = false,
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
  },
  {
    "ramojus/mellifluous.nvim",
    commit = "b77332a146f54ee3722fd8d64b9ec69b3e72f11b",
    config = function()
      require("mellifluous").setup({
        mellifluous = {
          styles = {
            types = { bold = true, italic = true },
          },
          color_overrides = {
            dark = {
              other_keywords = "#7E97AB",
              main_keywords = "#b46958",
              types = "#FFFFFF",
              operators = "#999999",
              strings = "#A2B5C1",
              functions = "#88afa2",
              constants = "#b46958",
              comments = "#727272",
            },
          },
        },
        transparent_background = {
          enabled = true,
          floating_windows = false,
          telescope = true,
          file_tree = true,
          cursor_line = true,
          status_line = true,
        },
      })
    end,
  },
  {
    "Mofiqul/vscode.nvim",
    config = function()
      require("vscode").setup({
        style = "light",
        transparent = true,
        italic_comments = true,
        underline_links = true,
        disable_nvimtree_bg = false,
      })
    end,
  },
}
