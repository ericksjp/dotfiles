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
        "<leader>ha",
        function()
          harpoon:list():add()
          print("Added to Harpoon")
        end,
        desc = "Harpoon Add File",
      },
      {
        "<leader>hd",
        function()
          harpoon:list():remove()
          print("Deleted from Harpoon")
        end,
        desc = "Harpoon Delete File",
      },
      {
        "<leader>he",
        function()
          harpoon:list():clear()
          print("Erase Harpoon list")
        end,
        desc = "Harpoon Erase List",
      },
      {
        "<leader>H",
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },
      {
        "<C-p>",
        function()
          harpoon:list():prev({ ui_nav_wrap = true })
        end,
        desc = "Harpoon Prev",
      },
      {
        "<C-n>",
        function()
          harpoon:list():next({ ui_nav_wrap = true })
        end,
        desc = "Harpoon Next",
      },
    }

    for i, v in ipairs({ "h", "j", "k", "l", "b" }) do
      local item = harpoon:list():get(i)
      local filename = ""
      if item then
        filename = item.value
      end

      table.insert(keys, {
        "<leader>h" .. v,
        function()
          harpoon:list():select(i)
        end,
        desc = "Harpoon to File " .. i .. ": " .. filename,
      })
    end

    return keys
  end,
}
