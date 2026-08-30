return {
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup({
      padding = true,
      sticky = true,
      ignore = nil,
      toggler = {
        line = "gb",
        block = "gb",
      },
      opleader = {
        line = "gb",
        block = "gb",
      },
      extra = {
        above = nil,
        below = nil,
        eol = "gcA",
      },
      mappings = {
        basic = true,
        extra = true,
      },
      pre_hook = nil,
      post_hook = nil,
    })
  end,
}
