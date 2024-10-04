local M = {}

M.pineDir = "/home/erick/"

M.setPineDir = function(dir)
  M.pineDir = dir
  print("PineDirectory =", dir)
end

M.getPineDir = function()
  return M.pineDir
end

return M
