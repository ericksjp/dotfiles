return {
  "kylechui/nvim-surround",
  version = "*",
  event = "VeryLazy",
  config = function()

    vim.keymap.set("x", "s", "<Plug>(nvim-surround-visual)", { noremap = false })
    vim.keymap.set("x", "S", "<Plug>(nvim-surround-visual-line)", { noremap = false })
    require("nvim-surround").setup({
      keymaps = {
        visual = "s",
        visual_line = "S",
      },
      aliases = {
        ["q"] = "'",
        ["Q"] = '"',
      },
    })
  end,
}
