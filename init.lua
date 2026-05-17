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

-- Protect against invalid buffer access in NvChad tabufline
-- MUST be done BEFORE NvChad loads to prevent it from caching unprotected API references
local original_buf_get_name = vim.api.nvim_buf_get_name
vim.api.nvim_buf_get_name = function(bufnr)
    if bufnr == 0 or vim.api.nvim_buf_is_valid(bufnr) then
        return original_buf_get_name(bufnr)
    end
    return ""
end

-- Protect buffer option access (deprecated API)
local original_buf_get_option = vim.api.nvim_buf_get_option
vim.api.nvim_buf_get_option = function(bufnr, opt)
    if bufnr == 0 or vim.api.nvim_buf_is_valid(bufnr) then
        return original_buf_get_option(bufnr, opt)
    end
    -- Return safe defaults for common options
    if opt == "buftype" or opt == "filetype" then
        return ""
    elseif opt == "modified" or opt == "modifiable" then
        return false
    end
    return nil
end

-- Protect nvim_get_option_value (modern API used by tabufline)
local original_get_option_value = vim.api.nvim_get_option_value
vim.api.nvim_get_option_value = function(opt, opts)
    opts = opts or {}
    if opts.buf then
        -- Validate buffer if specified
        if opts.buf ~= 0 and not vim.api.nvim_buf_is_valid(opts.buf) then
            -- Return safe defaults for invalid buffers
            if opt == "buftype" or opt == "filetype" then
                return ""
            elseif opt == "modified" or opt == "modifiable" or opt == "buflisted" then
                return false
            end
            return nil
        end
    end
    return original_get_option_value(opt, opts)
end

-- Protect vim.bo metatable access
local original_bo = vim.bo
local bo_mt = {
    __index = function(t, bufnr)
        -- Only validate if bufnr is actually a number
        if type(bufnr) == "number" then
            if bufnr == 0 or vim.api.nvim_buf_is_valid(bufnr) then
                return original_bo[bufnr]
            end
            -- Return an empty table for invalid buffer numbers
            return setmetatable({}, {
                __index = function() return nil end,
                __newindex = function() end,
            })
        end
        -- For non-number indices, pass through to original
        return original_bo[bufnr]
    end,
}
vim.bo = setmetatable({}, bo_mt)

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

-- Block duplicate LSP attachments
local attached_clients = {} -- Track which clients are attached to which buffers

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("BlockDuplicateLSP", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        local bufnr = args.buf
        local client_name = client.name

        -- Helper function to safely stop a client
        local function stop_client_safe(client_id, reason)
            local client_to_stop = vim.lsp.get_client_by_id(client_id)
            if client_to_stop and not client_to_stop.is_stopped() then
                vim.lsp.stop_client(client_id, true) -- force = true
                vim.notify("Blocked " .. reason, vim.log.levels.DEBUG)
            end
        end

        -- TypeScript: typescript-tools.nvim is authoritative
        -- Always block ts_ls/tsserver in favor of typescript-tools
        if client_name == "ts_ls" or client_name == "tsserver" then
            stop_client_safe(client.id, client_name .. " (using typescript-tools)")
            return
        end

        -- Rust: rustaceanvim is authoritative
        -- Block both rust_analyzer and duplicate rust-analyzer instances
        if client_name == "rust_analyzer" or client_name == "rust-analyzer" then
            -- Always block rust_analyzer (underscore) in favor of rust-analyzer (hyphen)
            if client_name == "rust_analyzer" then
                stop_client_safe(client.id, "rust_analyzer (using rustaceanvim)")
                return
            end

            -- For rust-analyzer (hyphen), check if it's a duplicate
            if client_name == "rust-analyzer" then
                local rust_clients = vim.lsp.get_clients({ bufnr = bufnr, name = "rust-analyzer" })
                -- If there are already 2+ rust-analyzer clients, this is a duplicate
                if #rust_clients > 1 then
                    stop_client_safe(client.id, "duplicate rust-analyzer")
                    return
                end
            end
        end

        -- Initialize tracking for this buffer if needed
        attached_clients[bufnr] = attached_clients[bufnr] or {}

        -- Check if this client name is already attached to this buffer
        if attached_clients[bufnr][client_name] then
            vim.lsp.stop_client(client.id)
            vim.notify(
                "Blocked duplicate " .. client_name .. " on buffer " .. bufnr,
                vim.log.levels.DEBUG
            )
            return
        end

        -- Mark this client as attached
        attached_clients[bufnr][client_name] = client.id
    end,
})

-- Clean up tracking when buffer is deleted
vim.api.nvim_create_autocmd("BufDelete", {
    group = vim.api.nvim_create_augroup("CleanupLSPTracking", { clear = true }),
    callback = function(args)
        attached_clients[args.buf] = nil
    end,
})

-- Clean up tracking when LSP client detaches
vim.api.nvim_create_autocmd("LspDetach", {
    group = vim.api.nvim_create_augroup("CleanupLSPDetach", { clear = true }),
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and attached_clients[bufnr] then
            attached_clients[bufnr][client.name] = nil
        end
    end,
})

-- Debug commands and keymaps for LSP
vim.api.nvim_create_user_command("LspClients", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        vim.notify("No LSP clients attached to current buffer", vim.log.levels.INFO)
        return
    end

    local msg = "LSP clients for buffer " .. vim.api.nvim_get_current_buf() .. ":\n"
    for _, client in ipairs(clients) do
        msg = msg .. "  - " .. client.name .. " (id: " .. client.id .. ")\n"
    end
    vim.notify(msg, vim.log.levels.INFO)
end, { desc = "Show LSP clients attached to current buffer" })

-- Keymap to quickly check LSP clients
vim.keymap.set("n", "<leader>li", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        vim.notify("No LSP clients attached", vim.log.levels.WARN)
        return
    end

    local client_names = {}
    for _, client in ipairs(clients) do
        table.insert(client_names, client.name)
    end

    vim.notify("LSP: " .. table.concat(client_names, ", "), vim.log.levels.INFO)
end, { desc = "Show attached LSP clients" })
