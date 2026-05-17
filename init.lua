vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        repo,
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

-- load plugins
require("lazy").setup({
    {
        "NvChad/NvChad",
        lazy = false,
        branch = "v2.5",
        import = "nvchad.plugins",
        config = function()
            require("options")
        end,
    },

    { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require("nvchad.autocmds")

vim.schedule(function()
    require("mappings")
end)

local original_buf_get_name = vim.api.nvim_buf_get_name
vim.api.nvim_buf_get_name = function(bufnr)
    if bufnr == 0 or vim.api.nvim_buf_is_valid(bufnr) then
        return original_buf_get_name(bufnr)
    end
    return ""
end

-- Block duplicate LSP attachments
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("BlockDuplicateLSP", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        -- TypeScript: typescript-tools.nvim is authoritative
        if client.name == "ts_ls" or client.name == "tsserver" then
            vim.schedule(function()
                client.stop()
            end)
            return
        end

        -- Rust: only allow the first rust_analyzer (rustaceanvim usually wins).
        -- Any subsequent rust_analyzer attachment is killed.
        if client.name == "rust_analyzer" then
            local existing = vim.lsp.get_clients({ name = "rust_analyzer" })
            if #existing > 1 then
                vim.schedule(function()
                    client.stop()
                end)
            end
        end
    end,
})
