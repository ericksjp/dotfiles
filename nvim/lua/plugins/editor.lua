return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        char = {
          enabled = false,
        },
      },
      jump = {
        autojump = true,
      },
      label = {
        style = "inline", ---@type "eol" | "overlay" | "right_align" | "inline"
        rainbow = {
          enabled = true,
          shade = 1,
        },
      },
      highlight = {
        matches = true,
        backdrop = false,
      },
    },
    keys = function()
      local f = require("flash")
      return {
        { "s", mode = { "n", "x", "o" }, false },
        { "S", mode = { "n", "x", "o" }, false },
        { "R", mode = { "o", "x" }, false },
        {
          "<c-f>",
          mode = { "c" },
          function()
            f.toggle()
          end,
          desc = "Toggle Flash Search",
        },
        {
          "f",
          mode = { "n", "x", "o" },
          function()
            f.jump()
          end,
          desc = "Flash",
        },
        {
          "F",
          mode = { "n", "o", "x" },
          function()
            f.treesitter()
          end,
          desc = "Flash Treesitter",
        },
        {
          "r",
          mode = "o",
          function()
            f.remote()
          end,
          desc = "Remote Flash",
        },
      }
    end,
  },
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {},
  },
}
