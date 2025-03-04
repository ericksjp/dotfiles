return {
  "stevearc/oil.nvim",
  enabled = false,
  config = function()
    local oil = require("oil")
    local detail = false

    oil.setup({
      float = {
        padding = 2,
        max_width = 0.5,
        max_height = 0.5,
        get_win_title = function()
          return oil.get_current_dir() .. " - " .. require("utils.smart").CurrentDir()
        end,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        preview_split = "below",
        override = function(conf)
          return conf
        end,
      },
      default_file_explorer = false,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        -- ["q"] = { "actions.close", mode = "n" },
        ["<esc>"] = { "actions.close", mode = "n" },
        ["H"] = { "actions.toggle_hidden", mode = "n" },
        ["e"] = { "actions.parent", mode = "n" },
        ["m"] = "actions.select",
        ["<CR>"] = "actions.select",
        ["<localleader>l"] = { "actions.select", opts = { vertical = true } },
        ["<localleader>j"] = { "actions.select", opts = { horizontal = true } },
        ["<localleader>t"] = { "actions.select", opts = { tab = true } },
        ["<localleader>r"] = "actions.refresh",
        ["<localleader>p"] = "actions.preview",
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
        ["<localleader>,"] = { "actions.cd", mode = "n" },
        ["<localleader>c"] = { "actions.open_cwd", mode = "n" },
        ["<localleader>o"] = { "actions.change_sort", mode = "n" },
        ["<localleader>e"] = "actions.open_external",
        ["<localleader>g"] = { "actions.toggle_trash", mode = "n" },
        ["<localleader>y"] = { "actions.yank_entry", mode = "n" },
        ["<localleader>k"] = {
          desc = "Toggle file and details",
          callback = function()
            detail = not detail
            if detail then
              oil.set_columns({ "icon", "permissions", "size", "mtime" })
            else
              oil.set_columns({ "icon" })
            end
          end,
        },
        ["<localleader>s"] = {
          desc = "Set Pined Directory",
          callback = function()
            local entry = oil.get_cursor_entry()
            if entry.type == "directory" then
              local path = oil.get_current_dir() .. entry.name
              require("utils.pined").set_pined(path)
            end
          end,
        },
        ["<Tab>"] = {
          desc = "Move to Another Directory",
          callback = function()
            require("utils.smart").MiniFiles(true)
          end,
        },
        ["<C-s>"] = {
          desc = "Save changes",
          callback = function()
            require("oil").save(nil, function(err)
              if err then
                print("Error: " .. err)
              end
              require("oil").close()
            end)
          end,
        },
      },
      use_default_keymaps = false,
    })
  end,
}
