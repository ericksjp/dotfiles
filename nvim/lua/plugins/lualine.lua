return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "kyazdani42/nvim-web-devicons",
    "AndreM222/copilot-lualine",
  },
  config = function()
    local lualine = require("lualine")
    local harpoon = require("harpoon")

    local colors = {
      bg = "#202328",
      fg = "#bbc2cf",
      yellow = "#ECBE7B",
      cyan = "#008080",
      darkblue = "#081633",
      green = "#98be65",
      orange = "#FF8800",
      violet = "#a9a1e1",
      magenta = "#c678dd",
      blue = "#51afef",
      red = "#ec5f67",
    }

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
      check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
      end,
      is_oil_buffer = function()
        return not (vim.bo.filetype == "neo-tree" or vim.bo.filetype == "oil")
      end,
      hide_if_oil = function(value)
        return function()
          return value and (vim.bo.filetype ~= "neo-tree" and vim.bo.filetype ~= "oil")
        end
      end,
    }

    local config = {
      options = {
        component_separators = "",
        section_separators = "",
        theme = {
          normal = { c = { fg = colors.fg, bg = "#1a1a1a" } },
          inactive = { c = { fg = colors.fg, bg = colors.bg } },
        },
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
    }

    local function ins_left(component)
      table.insert(config.sections.lualine_c, component)
    end

    local function ins_right(component)
      table.insert(config.sections.lualine_x, component)
    end

    ins_left({
      "mode",
      color = { gui = "bold" },
      cond = conditions.is_oil_buffer,
    })

    ins_left({
      require("utils.smart").CurrentDir,
      cond = function()
        return not conditions.is_oil_buffer()
      end,
    })

    ins_left({
      "filename",
      path = 1,
      color = { gui = "bold" },
      cond = conditions.hide_if_oil(conditions.buffer_not_empty),
    })

    ins_left({
      "diff",
      symbols = { added = " ", modified = "󰝤 ", removed = " " },
      diff_color = {
        added = { fg = colors.green },
        modified = { fg = colors.orange },
        removed = { fg = colors.red },
      },
      cond = conditions.hide_if_oil(conditions.hide_in_widt),
    })

    ins_left({
      function()
        local rbufname = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
        for i, item in ipairs(harpoon:list().items) do
          if rbufname == item.value then
            return "H" .. i
          end
        end
        return ""
      end,
      color = { fg = colors.green },
      cond = conditions.hide_if_oil(conditions.buffer_not_empty),
    })

    ins_left({
      "branch",
      icon = "",
      color = { fg = colors.violet, gui = "bold" },
      cond = conditions.hide_if_oil(conditions.check_git_workspace),
    })

    ins_left({
      "diagnostics",
      sources = { "nvim_diagnostic" },
      symbols = { error = " ", warn = " ", info = " " },
      diagnostics_color = {
        error = { fg = colors.red },
        warn = { fg = colors.yellow },
        info = { fg = colors.cyan },
      },
    })

    ins_right({
      require("recorder").displaySlots,
      cond = conditions.is_oil_buffer,
    })

    ins_right({
      require("recorder").recordingStatus,
      cond = conditions.is_oil_buffer,
    })

    ins_right({
      function()
        local msg = ""
        local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
        local clients = vim.lsp.get_clients()
        if next(clients) == nil then
          return msg
        end
        for _, client in ipairs(clients) do
          local filetypes = client.config.filetypes
          if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name
          end
        end
        return msg
      end,
      -- icon = "LSP:",
      -- color = { gui = "bold" },
      cond = conditions.is_oil_buffer,
    })

    ins_right({
      "copilot",
      cond = conditions.is_oil_buffer,
    })

    ins_right({
      "progress",
      color = { gui = "bold" },
      cond = conditions.is_oil_buffer,
    })
    ins_right({
      "location",
      cond = conditions.is_oil_buffer,
    })

    lualine.setup(config)
  end,
}
