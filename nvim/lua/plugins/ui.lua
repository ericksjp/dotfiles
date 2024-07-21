return {
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          component_separators = { left = "-", right = "-" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              padding = { left = 0 },
              color = { fg = "none", bg = "none", gui = "bold" },
            },
          },
          lualine_b = { "branch" },
          lualine_c = { "filename" },
          lualine_x = {
            function()
              local reg = vim.fn.reg_recording()
              if reg == "" then
                return ""
              end
              return "recording @" .. reg
            end,
          },
          lualine_y = { { "progress", color = { fg = "none", bg = "none" } } },
          lualine_z = {
            {
              "location",
              color = { fg = "none", bg = "none", gui = "bold" },
            },
          },
        },
      })
    end,
  },

  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
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
        view = "cmdline", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
        format = {
          cmdline = {
            icon = " :",
          },
          lua = {
            icon = " :𝗟",
          },
          filter = {
            icon = " :$",
          },
          help = {
            icon = " :",
          },
          search_down = {
            icon = "  ",
          },
          search_up = {
            icon = "  ",
          },
        },
      }

      opts.popupmenu = {
        backend = "cmp",
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
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 2000,
      fps = 120,
      render = "wrapped-compact",
      stages = "slide",
    },
  },
  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },
}
