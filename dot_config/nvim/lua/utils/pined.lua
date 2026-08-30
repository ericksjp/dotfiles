local M = {}

local pined = nil

M.set_pined = function(pinePath)
  if vim.fn.isdirectory(pinePath) == 0 then
    vim.notify("PineDirectory = " .. pinePath .. " is not a directory", vim.log.levels.ERROR)
    return
  end

  local path = vim.fn.getcwd() .. "/.vim"
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
  local pinefile = path .. "/pinefile"
  vim.fn.writefile({ pinePath }, pinefile)
  pined = pinePath
  vim.notify("Pined Directory = " .. pinePath, vim.log.levels.INFO)
end

M.load_pined = function()
  local path = vim.fn.getcwd() .. "/.vim"
  local pinefile = path .. "/pinefile"
  if vim.fn.isdirectory(path) == 0 or vim.fn.filereadable(pinefile) == 0 then
    pined = nil
    return
  end
  if vim.fn.isdirectory(vim.fn.readfile(pinefile)[1]) == 0 then
    vim.notify("Pined Directory = " .. vim.fn.readfile(pinefile)[1] .. " is not a directory", vim.log.levels.ERROR)
    return
  end
  pined = vim.fn.system("cat " .. pinefile):gsub("\n$", "")
  vim.notify("Pined Directory Loaded = " .. pined, vim.log.levels.INFO)
end

M.get_pined = function()
  return pined
end

return M
