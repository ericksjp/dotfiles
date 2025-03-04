local function startFunc()
  local filePath = vim.fn.stdpath("data") .. "/bgfile"

  local fileDescriptor = vim.uv.fs_open(filePath, "r", 436)
  if not fileDescriptor then return end

  local fileStat = vim.uv.fs_stat(filePath)
  if not fileStat then return end

  local fileData = vim.uv.fs_read(fileDescriptor, fileStat.size)
  if not fileData then return end

  fileData = vim.trim(fileData)
  if fileData == "1" then vim.cmd("set background=light") end

  vim.uv.fs_close(fileDescriptor)
end
vim.defer_fn(startFunc, 0)

-- feeding zoxide
vim.api.nvim_create_autocmd("DirChanged", {
  pattern = "*",
  callback = function()
    os.execute("zoxide add " .. vim.fn.getcwd())
  end,
})

vim.api.nvim_create_autocmd("DirChanged", {
  pattern = "*",
  callback = function()
    require("utils.pined").load_pined()
  end,
})

-- disable semantic tokens for java
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "jdtls" then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.diagnostic.config({
      virtual_text = false,
    })
  end,
  once = true,
})

vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = function()
    local opt = vim.api.nvim_get_option_value("background", {
      scope = "global",
    })
    if opt == "light" then
      vim.cmd("colorscheme github_light")
      require("lualine").setup({
        options = {
          theme = "onelight",
        },
      })
    else
      vim.cmd("colorscheme hybrid")
      require("lualine").setup({
        options = {
          theme = {
            normal = { c = { fg = "#bbc2cf", bg = "#1a1a1a" } },
            inactive = { c = { fg = "#bbc2cf", bg = "#202328" } },
          },
        },
      })
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "plaintext", "typst", "gitcommit", "markdown", "nofile", "oil" },
  callback = function()
    vim.opt_local.wrap = false
    vim.opt_local.spell = false
  end,
})
