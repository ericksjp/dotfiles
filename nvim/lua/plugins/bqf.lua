---@diagnostic disable: missing-fields
return {
  "kevinhwang91/nvim-bqf",
  config = function()
    require("bqf").setup({
      auto_enable = true,
      auto_resize_height = true,
      preview = {
        win_height = 100,
        win_vheight = 12,
        delay_syntax = 80,
        show_title = true,
        should_preview_cb = function(bufnr, qwinid)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then
            -- skip file size greater than 100k
            ret = false
          elseif bufname:match("^fugitive://") then
            -- skip fugitive buffer
            ret = false
          end
          return ret
        end,
      },
      func_map = {
        filterr = "x",
        filter = ",",
        drop = "D",
        openc = "O",
        split = "<C-s>",
        tabdrop = "<C-t>",
      },
    })
  end,
}
