local maps = function(bufnr)
  local function opts(desc)
    return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  vim.keymap.set("n", "<leader>rs", "<cmd>lua require('kulala').run()<cr>", opts("Send the request"))
  vim.keymap.set("n", "<leader>rt", "<cmd>lua require('kulala').toggle_view()<cr>", opts("Toggle the view"))
  vim.keymap.set("n", "<leader>rp", "<cmd>lua require('kulala').jump_prev()<cr>", opts("Jump to previous request"))
  vim.keymap.set("n", "<leader>rn", "<cmd>lua require('kulala').jump_next()<cr>", opts("Jump to next request"))
end

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.http",
  callback = function()
    maps(vim.fn.bufnr())
  end,
})

return {
  "mistweaverco/kulala.nvim",
  lazy = true,
  config = function()
    require("kulala").setup()
  end,
}
