local M = {}
local pineDir = "/home/erick/"

M.SetPineDir = function()
  pineDir = vim.fn.expand("%:p:h")
  print("PineDirectory =", pineDir)
end

M.getPineDir = function()
  return pineDir
end

return M
