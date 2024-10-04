-- one day this might be useful
local M = {}

function M.getDirectoryPathFromInput(inputPath)
  local cleanPath
  if vim.fn.isdirectory(inputPath) == 1 then
    cleanPath = inputPath
  else
    cleanPath = vim.fn.fnamemodify(inputPath, ":h")
  end
  return cleanPath
end

function M.glueQuotes(tbl)
  local newTable = {}
  local i = 1
  while i <= #tbl do
    local str = ""
    if vim.tbl_contains({ "'", '"' }, tbl[i]:sub(1, 1)) then
      str = tbl[i]
      local q = tbl[i]:sub(1, 1)
      while str:sub(-1) ~= q do
        str = str .. " " .. tbl[i + 1]
        i = i + 1
      end
      table.insert(newTable, str)
    else
      str = tbl[i]
      table.insert(newTable, str)
    end
    i = i + 1
  end
  return newTable
end

function M.type(path)
  if path:sub(-1, -1) == "/" then
    return "dir"
  elseif path:sub(-2, -2) == "/" and vim.tbl_contains({ "'", '"' }, path:sub(-1, -1)) then
    return "dir"
  else
    return "file"
  end
end

function M.create(fullPath)
  if M.type(fullPath) == "dir" then
    vim.fn.system("mkdir -p " .. fullPath)
  else
    vim.fn.system("touch " .. fullPath)
  end
end

function M.createFiles(path, filesT)
  for _, f in ipairs(filesT) do
    M.create(path .. "/" .. f)
  end
end

return M
