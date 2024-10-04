local M = {}

M.listMarks = function()
  local marks = vim.fn.execute("marks")
  local alpha_marks = {}

  for line in marks:gmatch("[^\r\n]+") do
    local mark = line:match("^%s*([a-z])%s+")
    if mark then
      table.insert(alpha_marks, line)
    end
  end

  require("fzf-lua").fzf_exec(alpha_marks, {
    prompt = "Marks> ",
    winopts = { height = 0.5, width = 0.5 },
    previewer = false,
    fzf_opts = {
      ["--pointer"] = "|",
    },
    actions = {
      ["default"] = function(selected)
        local mark = selected[1]:sub(2, 2)
        if mark then
          vim.cmd("normal! g`" .. mark)
        end
      end,
    },
  })
end

M.goToMark = function()
  local key = vim.fn.getchar()
  local char = vim.fn.nr2char(key)

  if char == "," then
    return vim.cmd("normal! [`")
  elseif char == "." then
    return vim.cmd("normal! ]`")
  end

  vim.cmd("normal! g`" .. char)
end

M.deleteMark = function()
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
