return {
  "mikesmithgh/kitty-scrollback.nvim",
  enabled = true,
  lazy = true,
  cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
  event = { "User KittyScrollbackLaunch" },
  -- version = '*', -- latest stable version, may have breaking changes if major version changed
  -- version = '^5.0.0', -- pin major version, include fixes and features that do not have breaking changes
  config = function()
    vim.opt.wrap = false
    vim.opt.signcolumn = "no"
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.opt.colorcolumn = ""

    require("kitty-scrollback").setup({
      search = {
        callbacks = {
          -- after_ready = function()
          --   vim.api.nvim_feedkeys("?", "n", false)
          -- end,
          after_paste_window_ready = function()
            vim.defer_fn(function()
              vim.cmd("silent! q")
            end, 10)
          end,
        },
      },
    })
  end,
}
