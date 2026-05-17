local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local M = {}

M.servers = {
    lua_ls = {
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
        settings = {
            Lua = {
                diagnostics = { enable = true, globals = { "vim" } },
                workspace = {
                    library = {
                        vim.fn.expand("$VIMRUNTIME/lua"),
                        vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                        vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                        vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                        "${3rd}/love2d/library",
                    },
                    maxPreload = 100000,
                    preloadFileSize = 10000,
                },
            },
        },
    },

    clangd = {
        on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            on_attach(client, bufnr)
        end,
        on_init = on_init,
        capabilities = capabilities,
    },

    gopls = {
        on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            on_attach(client, bufnr)
        end,
        on_init = on_init,
        capabilities = capabilities,
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gotmpl", "gowork" },
        settings = {
            gopls = {
                analyses = { unusedparams = true },
                completeUnimported = true,
                usePlaceholders = true,
                staticcheck = true,
            },
        },
    },

    prismals = {
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
        filetypes = { "prisma" },
        settings = {
            prisma = {
                prismaFmtBinPath = "",
            },
        },
    },

    taplo = {
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
        filetypes = { "toml" },
        settings = {
            evenBetterToml = {
                schema = {
                    enabled = true,
                    links = true,
                },
            },
        },
    },
}

return M
