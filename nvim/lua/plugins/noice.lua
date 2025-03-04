return {
  "folke/noice.nvim",
  enabled = true,
  opts = function(_, opts)
    table.insert(opts.routes, {
      filter = {
        event = "notify",
        find = "No information available",
      },
      opts = { skip = true },
    })
    local focused = true
    vim.api.nvim_create_autocmd("FocusGained", {
      callback = function()
        focused = true
      end,
    })
    vim.api.nvim_create_autocmd("FocusLost", {
      callback = function()
        focused = false
      end,
    })
    table.insert(opts.routes, 1, {
      filter = {
        cond = function()
          return not focused
        end,
      },
      view = "notify_send",
      opts = { stop = false },
    })

    opts.lsp.progress = {
      enabled = false,
    }

    opts.views = {
      custom_mini = {
        backend = "mini",
        relative = "editor",
        align = "message-right",
        timeout = 3000,
        border = {
          style = "none",
        },
        position = {
          row = -1,
          col = -1,
        },
        size = "auto",
        win_options = {
          winblend = 50, -- Valor de transparência
          -- winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
        },
      },
    }

    opts.routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "custom_mini",
      },
    }

    opts.cmdline = {
      enabled = false,
      view = "cmdline", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
      -- format = {
      --   cmdline = {
      --     icon = " :",
      --   },
      --   lua = {
      --     icon = " :𝗟",
      --   },
      --   filter = {
      --     icon = " :$",
      --   },
      --   help = {
      --     icon = " :",
      --   },
      --   search_down = {
      --     icon = "  ",
      --   },
      --   search_up = {
      --     icon = "  ",
      --   },
      -- },
    }

    opts.popupmenu = {
      enabled = false,
      backend = "nui",
    }

    opts.messages = {
      enabled = false,
    }

    opts.commands = {
      all = {
        -- options for the message history that you get with `:Noice`
        view = "split",
        opts = { enter = true, format = "details" },
        filter = {},
      },
    }
  end,
}
