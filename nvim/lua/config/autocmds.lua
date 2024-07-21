vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
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

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    if vim.bo.filetype == "java" then
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

vim.cmd([[autocmd FileType * set formatoptions-=ro]])
