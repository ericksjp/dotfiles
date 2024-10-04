return {
  "aserowy/tmux.nvim",
  config = function()
    return require("tmux").setup()
  end,
  keys = function()
    local t = require("tmux")

    return {
      {
        "<C-l>",
        function()
          t.move_right()
        end,
        desc = "Move Right",
      },
      {
        "<C-h>",
        function()
          t.move_left()
        end,
        desc = "Move Right",
      },
      {
        "<C-j>",
        function()
          t.move_bottom()
        end,
        desc = "Move Bottom",
      },
      {
        "<C-k>",
        function()
          t.move_top()
        end,
        desc = "Move Top",
      },
    }
  end,
}
