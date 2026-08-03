local fzf = require("fzf-lua")
local actions = fzf.actions

local M = {}

local manual_selection = {}

M.track_selection = function(selected, _)
    manual_selection = selected or {}
end

M.fixed_qlist = function (selected, action_opts)
    local to_send = (#manual_selection > 0) and manual_selection or selected
    actions.file_sel_to_qf(to_send, action_opts)

    if (action_opts.__INFO.fnc == "live_grep") then
        vim.b.word = action_opts.__INFO.query or ""
    end

    manual_selection = {}
end

return M
