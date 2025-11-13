require("nvchad.options")

local o = vim.o

-- Indenting
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.relativenumber = true
o.cursorlineopt = "both" -- to enable cursorline!

-- set filetype for .CBL COBOL files.
-- vim.cmd([[ au BufRead,BufNewFile *.CBL set filetype=cobol ]])

-- Spell checking for specific filetypes
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "markdown", "gitcommit", "text", "prisma" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = { "en_us", "en_gb" }
    end,
})

vim.opt.spell = true
vim.opt.spelllang = { "en_us", "en_gb" }

-- UI highlights
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(
    0,
    "Comment",
    { fg = "#AAAAAA", bg = "none", italic = true }
)
