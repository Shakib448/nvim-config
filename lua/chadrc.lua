-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
    theme = "catppuccin",
    transparency = true,
    -- hl_override = {
    -- 	Comment = { italic = true },
    -- 	["@comment"] = { italic = true },
    -- },
}
M.ui = {
    statusline = {
        theme = "default",
        separator_style = "default",
        order = {
            "mode",
            "file",
            "git",
            "%=",
            "lsp_msg",
            "%=",
            "diagnostics",
            "cwd",
            "cursor",
        },
        modules = {
            lsp = function()
                return ""
            end,
        },
    },
}

return M
