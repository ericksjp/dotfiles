return {
  {
    "Jorenar/nvim-dap-disasm",
    dependencies = "igorlfs/nvim-dap-view",
    config = true,
  },
  {
    "igorlfs/nvim-dap-view",
    keys = {
      { "<leader>du", function() require("dap-view").toggle() end, desc = "Dap VIEW" },
    },
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dap-view")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
