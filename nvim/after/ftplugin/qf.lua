local Set = require("utils.functions").Set
local del_qf_item = function()
  local items = vim.fn.getqflist()
  local line = vim.fn.line(".")

  table.remove(items, line)
  vim.fn.setqflist(items, "r")

  if line > #items then
    line = line - 1
  end

  vim.api.nvim_win_set_cursor(0, { line, 0 })
end

local del_qf_file = function()
  local items = vim.fn.getqflist()
  local bufnr = items[vim.fn.line(".")].bufnr
  local new = vim.tbl_filter(function(val)
    return val.bufnr ~= bufnr
  end, items)
  vim.fn.setqflist(new, "r")
end

local del_qf_visual_select = function()
  local _, ls = unpack(vim.fn.getpos("v"))
  local _, le = unpack(vim.fn.getpos("."))
  local items = vim.fn.getqflist()
  local new = {}
  for i, item in ipairs(items) do
    if i < ls or i > le then
      table.insert(new, item)
    end
  end
  vim.fn.setqflist(new, "r")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "m", true)
end

vim.keymap.set("n", "dd", del_qf_item, { silent = true, buffer = true, desc = "Remove entry from QF" })
vim.keymap.set("n", "df", del_qf_file, { silent = true, buffer = true, desc = "Remove file entry from QF" })
vim.keymap.set("v", "d", del_qf_visual_select, { silent = true, buffer = true, desc = "Remove file entry from QF" })

vim.keymap.set("n", "o", function()
  local target_word = vim.b.word:gsub("/", "\\/")

  local replace = vim.fn.input({
    prompt = "Cdo '" .. target_word .. "' with: ",
    cancelreturn = false,
  })

  if replace == false then
    return
  end

  vim.cmd("cclose")

  vim.cmd("noautocmd silent! cdo s/" .. target_word .. "/" .. replace .. "/g")
end, { buffer = true, desc = "Replace word in QF" })

vim.keymap.set("n", "f", function()
  local target_word = vim.b.word:gsub("/", "\\/")

  local replace = vim.fn.input({ prompt = "Cfdo '" .. target_word .. "' with: ", cancelreturn = false })
  if not replace then
    return
  end

  vim.cmd("cclose")

  local active_buffers = Set(vim.fn.getbufinfo({ buflisted = 1 }))

  vim.g.close_untracked_buffers = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if not active_buffers[bufnr] then
      vim.cmd("bd " .. bufnr)
    end
  end

  vim.cmd(
    "noautocmd silent! cfdo %s/" .. target_word .. "/" .. replace .. "/g | update | lua vim.g.close_untracked_buffers()"
  )

  vim.g.close_untracked_buffers = nil
end, { buffer = true })
