return {
  "kylechui/nvim-surround",
  version = "*",
  event = "VeryLazy",
  config = function()
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
