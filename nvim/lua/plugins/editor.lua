return {
  {
    "ggandor/leap.nvim",
    dependencies = {
      "tpope/vim-repeat",
    },
    config = function()
      vim.keymap.set("n", "f", "<Plug>(leap)")
      vim.keymap.set("n", "F", "<Plug>(leap-from-window)")
      vim.keymap.set({ "x", "o" }, "f", "<Plug>(leap-forward)")
      vim.keymap.set({ "x", "o" }, "F", "<Plug>(leap-backward)")
      require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
    end,
  },
}
