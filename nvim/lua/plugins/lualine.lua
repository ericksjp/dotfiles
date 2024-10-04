local function clients_lsp()
  local bufnr = vim.api.nvim_get_current_buf()

  local clients = vim.lsp.buf_get_clients(bufnr)
  if next(clients) == nil then
    return ""
  end

  local c = {}
  for _, client in pairs(clients) do
    if client.name ~= "copilot" then
      table.insert(c, 1, client.name)
    else
      if vim.g.copilot_enabled == true then
        table.insert(c, 1, client.name)
      end
    end
  end

  return "LSP: " .. table.concat(c, ", ") .. ""
end

return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        -- theme = "wombat",
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            color = { gui = "bold" },
          },
        },
        lualine_b = { "branch" },
        lualine_c = {
          "filename",
          {
            function()
              return "H:" .. require("harpoon"):list()._index
            end,
          },
          { clients_lsp, color = { fg = "#98be65" } },
        },
        lualine_x = {},
        lualine_y = {
          {
            require("noice").api.status.command.get,
            cond = require("noice").api.status.command.has,
            color = { fg = "#ff9e64" },
          },
        },
        lualine_z = {
          { "progress", padding = { left = 1, right = 0 } },
          {
            "location",
            color = { gui = "bold" },
          },
        },
      },
    })
  end,
}
