local M = {}

M.delAutoMarks = function()
  vim.cmd("delm 0-9[]<>^.")
  vim.cmd('delmarks \\"')
end

M.gotoMark = function()
  local key = vim.fn.getchar()
  local char = vim.fn.nr2char(key)

  if char == "," then
    return vim.cmd("normal! [`")
  elseif char == "." then
    return vim.cmd("normal! ]`")
  end

  vim.cmd("normal! g`" .. char)
end

M.delMark = function()
  local key = vim.fn.getchar()
  local char = vim.fn.nr2char(key)

  vim.cmd("delmark " .. char)
end

M.putMark = function()
  local key = vim.fn.getchar()
  local char = vim.fn.nr2char(key)

  vim.cmd("mark " .. char)
end

return M
