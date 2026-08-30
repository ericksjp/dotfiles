return {
  'nanozuki/tabby.nvim',
  config = function()
    local theme = {
      current = { fg = "#cad3f5", bg = "none", style = "bold" },
      not_current = { fg = "#5b6078", bg = "none" },

      fill = { bg = "none" },
    }

    require('tabby').setup({
      line = function (line)
        return {
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current or theme.not_current
            return {
              line.sep(" ", hl, theme.fill),
              tab.name() == "" and "empty" or tab.name(),
              line.sep(" ", hl, theme.fill),
              hl = hl,
            }
          end),
        }
      end
    })
  end,
}
