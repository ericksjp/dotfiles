return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  init = function()
    -- vim.api.nvim_create_autocmd("User", {
    --   pattern = "OilActionsPost",
    --   callback = function(event)
    --     log.debug(vim.inspect(event))
    --     if event.data.actions.type == "move" then
    --       Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
    --     end
    --   end,
    -- })
  end,
  keys = {
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Buffer delete",
      mode = "n",
    },
    {
      "<leader>ba",
      function()
        Snacks.bufdelete.all()
      end,
      desc = "Buffer delete all",
      mode = "n",
    },
    {
      "<leader>bo",
      function()
        Snacks.bufdelete.other()
      end,
      desc = "Buffer delete other",
      mode = "n",
    },
},
  opts = {
    dashboard = { enabled = false },
    explorer = { enabled = false },
    -- explorer = { replace_netrw = true, },
    indent = { enabled = false },
    input = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = true },
    scope = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = false },
    rename = { enabled = true },
    animation = { enabled = false},
    image = {enabled = true},
    scroll = { enabled = false},
    picker = {
        actions = {
                smart = function(picker)
                    -- Snacks.picker.picker_layouts()
                    Snacks.picker.actions.close(picker)
                    vim.schedule(function()
                        require("utils.smart").FindFile(true)
                    end)
                end
        },
        -- layout = "ivy";
        win = {
            input = {
                keys = {
                    ["<Esc>"] = { "close", mode = { "n", "i" } },
                    ["<c-a>"] = { "select_and_next", mode = { "i", "n" } },
                }
            }
        }
    },
    zen = {
      enabled = true,
      toggles = {
        ufo = false,
        dim = false,
        git_signs = false,
        diagnostics = false,
        line_number = false,
        relative_number = false,
        signcolumn = "no",
        indent = false,
      },
    },
  },
}
