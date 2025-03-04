return {
  "ggandor/leap.nvim",
  dependencies = {
    "tpope/vim-repeat",
  },
  config = function()
    require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
  end,
}
