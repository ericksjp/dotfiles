function IsRecording()
  local reg = vim.fn.reg_recording()
  if reg == "" then
    return ""
  end
  return "recording @" .. reg
end

local function lualine_options(fg_color)
  return {
    sections = {
      lualine_a = {
        {
          "mode",
          padding = { left = 1 },
          color = { fg = fg_color, bg = "none", gui = "bold" },
        },
      },
      lualine_b = { "branch" },
      lualine_c = { "filename" },
      lualine_x = { "IsRecording()" },
      lualine_y = { { "progress", color = { fg = fg_color } } },
      lualine_z = {
        {
          "location",
          color = { fg = fg_color, bg = "none", gui = "bold" },
        },
      },
    },
  }
end

local function SET_COLORSCHEME()
  if vim.o.background == "dark" then
    vim.cmd("colorscheme mellifluous")
    require("lualine").setup(lualine_options("#ffffff"))
  else
    vim.cmd("colorscheme vscode")
    require("lualine").setup(lualine_options("#000000"))
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    SET_COLORSCHEME()
    local arg = vim.fn.argv(0)
    if arg == "." then
      vim.defer_fn(function()
        require("oil").open(vim.fn.getcwd())
      end, 10)
    end
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "oil://*",
  callback = function()
    os.execute("zoxide add " .. require("oil").get_current_dir())
  end,
})

vim.api.nvim_create_autocmd("DirChanged", {
  pattern = "*",
  callback = function()
    if ChangeWithCWD == true then
      local oilOpen = require("oil").get_current_dir()
      if oilOpen ~= nil and oilOpen ~= vim.fn.getcwd() then
        vim.defer_fn(function()
          require("oil.actions").open_cwd.callback()
        end, 10)
      end
    end
  end,
})

vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = SET_COLORSCHEME,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    if vim.bo.filetype == "java" then
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

vim.cmd([[autocmd FileType * set formatoptions-=ro]])
