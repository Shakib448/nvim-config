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
                diagnostics = { enable = false },
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

    ts_ls = {
        on_attach = on_attach,
        capabilities = capabilities,
        init_options = {
            preferences = { disableSuggestions = true },
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

    rust_analyzer = {
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
        settings = {
            ["rust-analyzer"] = {
                assist = {
                    importEnforceGranularity = true,
                    importPrefix = "crate",
                },
                cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true,
                    buildScripts = {
                        enable = true,
                    },
                    workspace = {},
                },
                checkOnSave = true,
                check = {
                    command = "clippy",
                    extraArgs = { "--all-targets", "--all-features" },
                },
                completion = {
                    autoimport = { enable = true },
                    postfix = { enable = true },
                },
                imports = {
                    granularity = { group = "module" },
                    prefix = "self",
                },
                inlayHints = {
                    locationLinks = false,
                    chainingHints = { enable = true },
                    closingBraceHints = {
                        enable = true,
                        minLines = 10,
                    },
                    parameterHints = { enable = true },
                    typeHints = {
                        enable = true,
                        hideClosureInitialization = false,
                        hideNamedConstructor = false,
                    },
                },
                procMacro = {
                    enable = true,
                    attributes = {
                        enable = true,
                    },
                },
                diagnostics = {
                    enable = true,
                    experimental = {
                        enable = true,
                    },
                    disabled = {},
                },
                lens = {
                    enable = true,
                    references = {
                        adt = { enable = true },
                        enumVariant = { enable = true },
                        method = { enable = true },
                        trait = { enable = true },
                    },
                    run = { enable = true },
                    debug = { enable = true },
                },
                hover = {
                    actions = {
                        references = { enable = true },
                    },
                },
                linkedProjects = {},
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
