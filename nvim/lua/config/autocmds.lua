vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    local arg = vim.fn.argv(0)
    if arg == "." then
      vim.defer_fn(function()
        require("oil").open(vim.fn.getcwd())
      end, 10)
      require("colorscheme-file").set_colorscheme()
    end
  end,
})

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*" },
  callback = function()
    local bufnames = { "^NvimTree_*", "^term://*", "^$" }
    local bufName = vim.fn.bufname()

    -- caso especial pq eu nao pq caralhos o regex nao pega com hifen
    if bufName == "copilot-chat" then
      return
    end

    for _, buf in pairs(bufnames) do
      if bufName:match(buf) then
        return
      end
    end

    vim.g.current_root_dir = LazyVim.root()
  end,
})

local log = require("plenary.log"):new()
log.level = "debug"

vim.api.nvim_create_autocmd("DirChanged", {
  pattern = "*",
  callback = function()
    local oil = require("oil").get_current_dir()
    if oil and oil ~= vim.fn.getcwd() then
      vim.defer_fn(function()
        require("oil").open(vim.fn.getcwd())
      end, 10)
    end
  end,
})

vim.api.nvim_create_autocmd("DirChanged", {
  pattern = "*",
  callback = function()
    os.execute("zoxide add " .. vim.fn.getcwd())
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

vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = function()
    local opt = vim.api.nvim_get_option_value("background", {
      scope = "global",
    })
    if opt == "light" then
      vim.cmd("colorscheme github_light_default")
    else
      vim.cmd("colorscheme vscode")
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = false
    vim.opt_local.spell = false
  end,
})

vim.cmd([[autocmd FileType * set formatoptions-=ro]])

vim.api.nvim_create_user_command("Nf", function(opts)
  local utils = require("utils.functions")
  local args = utils.glueQuotes(opts.fargs)
  local path = table.remove(args, 1)
  utils.createFiles(path, args)
end, { nargs = "*" })

vim.api.nvim_command("command! -nargs=1 R lua Rename(<f-args>)")
vim.api.nvim_command("command! -nargs=1 -complete=dir M lua Move(<f-args>)")

function Rename(newName)
  local bufname = vim.fn.expand("%:p")
  local dirname = vim.fn.expand("%:p:h")
  local newname = dirname .. "/" .. newName
  local result = vim.fn.rename(bufname, newname)
  if result == 0 then
    vim.cmd("e " .. newname)
    print("Renamed file to " .. newName)
  else
    print("Error renaming file")
  end
end

function Move(newPath)
  local bufname = vim.fn.expand("%:p")
  if newPath:sub(-1) ~= "/" then
    newPath = newPath .. "/"
  end
  local newname = newPath .. vim.fn.fnamemodify(bufname, ":t")
  local result = vim.fn.rename(bufname, newname)
  if result == 0 then
    vim.cmd("e " .. newname)
    print("Moved file to " .. newPath)
  else
    print("Error moving file")
  end
end
