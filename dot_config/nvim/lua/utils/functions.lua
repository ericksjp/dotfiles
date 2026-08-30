-- one day this might be useful
local M = {}

function M.getDirPathFromInput(inputPath)
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

function M.swap(a, b)
  return b, a
end

function M.get_visual()
  local _, ls, cs = unpack(vim.fn.getpos("v"))
  local _, le, ce = unpack(vim.fn.getpos("."))
  if ls > le or cs > ce then
    ls, le = M.swap(ls, le)
    cs, ce = M.swap(cs, ce)
  elseif ls == le and cs == ce then
    return vim.api.nvim_get_current_line()
  end
  return table.concat(vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {}), "")
end

function M.get_word()
  if vim.fn.mode() == "n" then
    return vim.fn.expand("<cword>")
  else
    return M.get_visual()
  end
end

function M.set_qf_word(word)
  if vim.bo.ft == "qf" then
    vim.b.word = word
    return true
  end
  return false
end

function M.Set(list)
  local set = {}
  for _, l in ipairs(list) do
    set[l.bufnr] = true
  end
  return set
end

return M
