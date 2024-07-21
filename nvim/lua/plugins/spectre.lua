return {
  "nvim-pack/nvim-spectre",
  config = function()
    require("spectre").setup({
      mapping = {
        ["run_replace"] = {
          map = "<c-j>",
          cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
          desc = "replace all",
        },
      },
    })
  end,
  keys = function()
    local function spectreOpen(dir)
      require("spectre").open({
        is_insert_mode = true,
        cwr = dir,
        search_text = vim.fn.expand("<cword>"),
      })
      vim.defer_fn(function()
        vim.cmd("5")
      end, 100)
    end

    return {

      ["<leader>rc"] = { spectreOpen, "Spectre - Current directory" },
      ["<leader>rr"] = {
        function()
          spectreOpen(LazyVim.root)
        end,
        "Spectre - Root directory",
      },
      ["<leader>rb"] = {
        function()
          spectreOpen(vim.fn.expand("%:p:h"))
        end,
        "Spectre - Buffer directory",
      },
      ["<leader>rp"] = {
        function()
          spectreOpen(PineDir)
        end,
        "Spectre - Pine directory",
      },
      ["<leader>rn"] = {
        function()
          local word = vim.fn.expand("<cword>")
          vim.ui.input({ prompt = "Replace " .. word .. " with: " }, function(sub)
            if sub then
              vim.cmd("%s/\\v" .. vim.fn.expand("<cword>") .. "/" .. sub .. "/g")
            else
              print("No input provided")
            end
          end)
        end,
        "Spectre - Replace word",
      },
    }
  end,
}
