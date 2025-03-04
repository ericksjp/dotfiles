return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "InsertEnter",
  config = function()
    local enabled = true

    require("copilot").setup({
      panel = {
        enabled = false,
      },
      suggestion = {
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          -- accept = "<tab>",
          dismiss = "<C-d>",
          suggest = "<C-,>",
          next = "<C-l>",
        },
      },
    })
  end,
}
