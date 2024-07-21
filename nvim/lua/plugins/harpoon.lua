return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
    },
  },
  keys = function()
    local harpoon = require("harpoon")

    local keys = {
      {
        "sa",
        function()
          harpoon:list():add()
          print("Added to Harpoon")
        end,
        desc = "Harpoon File",
      },
      {
        "<leader> ",
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },
      {
        "<C-Q>",
        function()
          harpoon:list():prev()
        end,
        desc = "Harpoon Prev",
      },
      {
        "<C-E>",
        function()
          harpoon:list():next()
        end,
        desc = "Harpoon Next",
      },
    }

    for i, v in ipairs({ "h", "j", "k", "l", "ç" }) do
      table.insert(keys, {
        "z" .. v,
        function()
          harpoon:list():select(i)
        end,
        desc = "Harpoon to File " .. i,
      })
    end
    return keys
  end,
}
