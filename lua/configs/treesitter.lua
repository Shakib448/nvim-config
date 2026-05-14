-- local options = {
--     ensure_installed = {
--         "bash",
--         -- "c",
--         -- "cmake",
--         -- "cpp",
--         "fish",
--         -- "go",
--         -- "gomod",
--         -- "gosum",
--         -- "gotmpl",
--         -- "gowork",
--         -- "haskell",
--         "lua",
--         "luadoc",
--         -- "make",
--         "markdown",
--         -- "odin",
--         "printf",
--         -- "python",
--         "toml",
--         "vim",
--         "vimdoc",
--         "yaml",
--     },
--
--     highlight = {
--         enable = true,
--         use_languagetree = true,
--     },
--
--     indent = { enable = true },
-- }
--
-- require("nvim-treesitter.configs").setup(options)

local options = {
    ensure_installed = {
        "bash",
        "fish",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline", -- ⬅️ recommended pair with markdown
        -- "printf",          -- ❌ REMOVED (was failing; not essential)
        "toml",
        "vim",
        "vimdoc",
        "yaml",
        "json", -- ⬅️ likely useful
        "typescript", -- ⬅️ you write TS
        "tsx",
        "javascript",
        "rust", -- ⬅️ you write Rust
    },
    ignore_install = { "printf" }, -- belt + suspenders
    highlight = {
        enable = true,
        use_languagetree = true,
    },
    indent = { enable = true },
    auto_install = false, -- ⬅️ explicit — don't auto-install broken parsers
}
require("nvim-treesitter.configs").setup(options)
