return {
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
        config = true,
        keys = {
            { "<leader>l", nil, desc = "AI/Claude Code" },
            {
                "<leader>lc",
                "<cmd>ClaudeCode<cr>",
                desc = "Toggle Claude",
            },
            {
                "<leader>lf",
                "<cmd>ClaudeCodeFocus<cr>",
                desc = "Focus Claude",
            },
            {
                "<leader>lr",
                "<cmd>ClaudeCode --resume<cr>",
                desc = "Resume Claude",
            },
            {
                "<leader>lC",
                "<cmd>ClaudeCode --continue<cr>",
                desc = "Continue last session",
            },
            {
                "<leader>lb",
                "<cmd>ClaudeCodeAdd %<cr>",
                desc = "Add current buffer",
            },
            {
                "<leader>ls",
                "<cmd>ClaudeCodeSend<cr>",
                mode = "v",
                desc = "Send selection",
            },
            {
                "<leader>la",
                "<cmd>ClaudeCodeDiffAccept<cr>",
                desc = "Accept diff",
            },
            {
                "<leader>ld",
                "<cmd>ClaudeCodeDiffDeny<cr>",
                desc = "Deny diff",
            },
        },
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        ft = {
            "typescript",
            "typescriptreact",
            "javascript",
            "javascriptreact",
        },
        opts = {
            settings = {
                tsserver_file_preferences = {
                    includeInlayParameterNameHints = "all",
                    includeCompletionsForModuleExports = true,
                    quotePreference = "auto",
                },
                tsserver_format_options = {
                    allowIncompleteCompletions = false,
                    allowRenameOfImportPath = false,
                },
            },
        },
        keys = {
            {
                "<leader>to",
                "<cmd>TSToolsOrganizeImports<cr>",
                desc = "TS: Organize imports",
            },
            {
                "<leader>tu",
                "<cmd>TSToolsRemoveUnusedImports<cr>",
                desc = "TS: Remove unused imports",
            },
            {
                "<leader>tU",
                "<cmd>TSToolsRemoveUnused<cr>",
                desc = "TS: Remove all unused",
            },
            {
                "<leader>ta",
                "<cmd>TSToolsAddMissingImports<cr>",
                desc = "TS: Add missing imports",
            },
            {
                "<leader>tf",
                "<cmd>TSToolsFixAll<cr>",
                desc = "TS: Fix all",
            },
            {
                "<leader>ts",
                "<cmd>TSToolsSortImports<cr>",
                desc = "TS: Sort imports",
            },
            {
                "<leader>tr",
                "<cmd>TSToolsRenameFile<cr>",
                desc = "TS: Rename file",
            },
            {
                "<leader>tR",
                "<cmd>TSToolsFileReferences<cr>",
                desc = "TS: File references",
            },
            {
                "gD",
                "<cmd>TSToolsGoToSourceDefinition<cr>",
                desc = "TS: Go to source definition",
            },
        },
        config = function(_, opts)
            require("typescript-tools").setup(opts)

            -- Auto-organize imports on save for TS/JS files
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
                callback = function(args)
                    -- Skip if typescript-tools isn't attached to this buffer yet
                    local clients = vim.lsp.get_clients({
                        bufnr = args.buf,
                        name = "typescript-tools",
                    })
                    if #clients == 0 then
                        return
                    end

                    -- pcall each one so a transient nil response doesn't abort the save
                    pcall(vim.api.nvim_command, "TSToolsAddMissingImports sync")
                    pcall(
                        vim.api.nvim_command,
                        "TSToolsRemoveUnusedImports sync"
                    )
                    pcall(vim.api.nvim_command, "TSToolsOrganizeImports sync")
                end,
            })
        end,
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^6",
        ft = { "rust" },
        init = function()
            local nvchad_lsp = require("nvchad.configs.lspconfig")
            vim.g.rustaceanvim = {
                server = {
                    on_attach = nvchad_lsp.on_attach,
                    capabilities = nvchad_lsp.capabilities,
                    default_settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                buildScripts = { enable = true },
                            },
                            check = {
                                command = "clippy",
                                extraArgs = {
                                    "--all-targets",
                                    "--all-features",
                                },
                            },
                            imports = {
                                granularity = { group = "module" },
                                prefix = "self",
                            },
                            completion = {
                                autoimport = { enable = true },
                                postfix = { enable = true },
                            },
                            inlayHints = {
                                chainingHints = { enable = true },
                                parameterHints = { enable = true },
                                typeHints = {
                                    enable = true,
                                    hideClosureInitialization = false,
                                    hideNamedConstructor = false,
                                },
                                closingBraceHints = {
                                    enable = true,
                                    minLines = 10,
                                },
                            },
                            procMacro = {
                                enable = true,
                                attributes = { enable = true },
                            },
                            lens = {
                                enable = true,
                                run = { enable = true },
                                debug = { enable = true },
                                references = {
                                    adt = { enable = true },
                                    enumVariant = { enable = true },
                                    method = { enable = true },
                                    trait = { enable = true },
                                },
                            },
                            hover = {
                                actions = {
                                    references = { enable = true },
                                },
                            },
                        },
                    },
                },
            }
        end,
        keys = {
            {
                "<leader>rm",
                function()
                    vim.cmd.RustLsp("expandMacro")
                end,
                desc = "Rust: Expand macro",
                ft = "rust",
            },
            {
                "<leader>rr",
                function()
                    vim.cmd.RustLsp("runnables")
                end,
                desc = "Rust: Runnables",
                ft = "rust",
            },
            {
                "<leader>rd",
                function()
                    vim.cmd.RustLsp("debuggables")
                end,
                desc = "Rust: Debuggables",
                ft = "rust",
            },
            {
                "<leader>re",
                function()
                    vim.cmd.RustLsp("explainError")
                end,
                desc = "Rust: Explain error",
                ft = "rust",
            },
            {
                "<leader>rc",
                function()
                    vim.cmd.RustLsp("openCargo")
                end,
                desc = "Rust: Open Cargo.toml",
                ft = "rust",
            },
            {
                "<leader>rp",
                function()
                    vim.cmd.RustLsp("parentModule")
                end,
                desc = "Rust: Parent module",
                ft = "rust",
            },
            {
                "<leader>rj",
                function()
                    vim.cmd.RustLsp("joinLines")
                end,
                desc = "Rust: Join lines (smart)",
                ft = "rust",
            },
            {
                "K",
                function()
                    vim.cmd.RustLsp({ "hover", "actions" })
                end,
                desc = "Rust: Hover with actions",
                ft = "rust",
            },
            {
                "<leader>ra",
                function()
                    vim.cmd.RustLsp("codeAction")
                end,
                desc = "Rust: Code action (rust-analyzer)",
                ft = "rust",
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.treesitter")
        end,
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },

        config = function()
            require("nvchad.configs.lspconfig").defaults()
            require("configs.lspconfig")
            vim.schedule(function()
                vim.diagnostic.config({
                    virtual_text = false,
                })
            end)
        end,
    },

    {
        "rcarriga/nvim-notify",
        lazy = false,
        priority = 1000,
        config = function()
            local notify = require("notify")

            notify.setup({
                background_colour = "#000000",
                timeout = 3000,
                render = "compact",
                stages = "fade_in_slide_out",
            })

            vim.notify = notify
        end,
    },

    {
        "NStefan002/screenkey.nvim",
        lazy = false,
        version = "*",
        opts = {
            win_opts = {
                relative = "editor",
                anchor = "NE",
                width = 40,
                height = 3,
                border = "rounded",
                title = "Keys",
                title_pos = "center",
            },
            compress_after = 3,
            clear_after = 3,
            show_leader = true,
            group_mappings = true,
        },
        keys = {
            { "<leader>sk", "<cmd>Screenkey<cr>", desc = "Toggle Screenkey" },
        },
        -- init = function()
        --     vim.defer_fn(function()
        --         vim.cmd("Screenkey")
        --     end, 200)
        -- end,
    },

    -- {
    --     "akinsho/toggleterm.nvim",
    --     version = "*",
    --     config = true,
    -- },

    {
        "Exafunction/windsurf.nvim",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({
                enable_cmp_source = false,
                virtual_text = {
                    enabled = true,
                    manual = false,
                    filetypes = {},
                    default_filetype_enabled = true,
                    idle_delay = 75,
                    virtual_text_priority = 65535,
                    map_keys = true,
                    accept_fallback = nil,
                    key_bindings = {
                        accept = "<C-g>",
                        accept_word = "<C-w>",
                        accept_line = "<C-l>",
                        clear = "<C-x>",
                        next = "<C-j>",
                        prev = "<C-k>",
                    },
                },
            })
        end,
    },

    {
        "letieu/btw.nvim",
        lazy = false,
        config = function()
            require("btw").setup({
                text = "Neovim BTW!",
            })
        end,
    },

    {
        "theprimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("harpoon"):setup()
        end,
        keys = {
            -- Mark file
            {
                "<leader>mm",
                function()
                    require("harpoon"):list():add()
                    vim.notify("✓ Marked!", vim.log.levels.INFO)
                end,
                desc = "Harpoon: Mark file",
            },
            {
                "<leader>a",
                function()
                    local harpoon = require("harpoon")
                    harpoon.ui:toggle_quick_menu(harpoon:list())
                end,
                desc = "Harpoon: Menu",
            },
            {
                "<leader>mr",
                function()
                    require("harpoon"):list():remove()
                    vim.notify("✓ Removed!", vim.log.levels.INFO)
                end,
                desc = "Harpoon: Remove current file",
            },
            {
                "<leader>mc",
                function()
                    require("harpoon"):list():clear()
                    vim.notify("✓ Cleared all!", vim.log.levels.WARN)
                end,
                desc = "Harpoon: Clear all",
            },
            {
                "<leader>1",
                function()
                    require("harpoon"):list():select(1)
                end,
                desc = "Harpoon: File 1",
            },
            {
                "<leader>2",
                function()
                    require("harpoon"):list():select(2)
                end,
                desc = "Harpoon: File 2",
            },
            {
                "<leader>3",
                function()
                    require("harpoon"):list():select(3)
                end,
                desc = "Harpoon: File 3",
            },
            {
                "<leader>4",
                function()
                    require("harpoon"):list():select(4)
                end,
                desc = "Harpoon: File 4",
            },
            {
                "<leader>5",
                function()
                    require("harpoon"):list():select(5)
                end,
                desc = "Harpoon: File 5",
            },
        },
    },

    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        opts = require("configs.tiny-inline-diagnostic"),
        config = function(_, opts)
            require("tiny-inline-diagnostic").setup(opts)
            require("configs.diagnostic-keymaps").setup()
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lspconfig" },
        config = function()
            require("configs.mason-lspconfig")
        end,
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.lint")
        end,
    },

    {
        "rshkarin/mason-nvim-lint",
        event = "VeryLazy",
        dependencies = { "nvim-lint" },
        config = function()
            require("configs.mason-lint")
        end,
    },

    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        config = function()
            require("configs.conform")
        end,
    },

    {
        "zapling/mason-conform.nvim",
        event = "VeryLazy",
        dependencies = { "conform.nvim" },
        config = function()
            require("configs.mason-conform")
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "▎" },
                    change = { text = "▎" },
                    delete = { text = "▎" },
                    topdelete = { text = "▔" },
                    changedelete = { text = "~" },
                },
                current_line_blame = true,
            })
        end,
    },
    {
        "luukvbaal/statuscol.nvim",
        config = function()
            -- Custom function to show both absolute and relative line numbers
            local function lnum_both()
                local lnum = vim.v.lnum
                local relnum = vim.v.lnum == vim.fn.line(".") and 0
                    or math.abs(vim.v.lnum - vim.fn.line("."))
                return string.format("%3d %2d", lnum, relnum)
            end
            require("statuscol").setup({
                setopt = true,
                segments = {
                    {
                        sign = {
                            namespace = { "gitsigns.*" },
                            name = { "gitsigns.*" },
                        },
                    },
                    {
                        sign = {
                            namespace = { ".*" },
                            name = { ".*" },
                            auto = true,
                        },
                    },
                    {
                        text = { lnum_both, " " },
                        condition = { true },
                        click = "v:lua.ScLa",
                    },
                },
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        ft = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
        },
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },

    {
        "nvimtools/none-ls.nvim",
        event = "VeryLazy",
        dependencies = { "davidmh/cspell.nvim" },
        opts = function(_, opts)
            local cspell = require("cspell")
            local null_ls = require("null-ls")

            opts.sources = opts.sources or {}

            -- Add cspell sources
            table.insert(
                opts.sources,
                cspell.diagnostics.with({
                    diagnostics_postprocess = function(diagnostic)
                        diagnostic.severity = vim.diagnostic.severity.HINT
                    end,
                })
            )
            table.insert(opts.sources, cspell.code_actions)

            -- Add the formatting on save functionality
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            opts.on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({
                        group = augroup,
                        buffer = bufnr,
                    })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            pcall(vim.lsp.buf.format, { bufnr = bufnr })
                            -- vim.lsp.buf.format({ bufnr = bufnr })
                        end,
                    })
                end
            end

            return opts
        end,
    },

    {
        "sindrets/diffview.nvim",
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("diffview").setup()
        end,
    },

    {
        "tpope/vim-dadbod",
        cmd = "DB",
    },

    {
        "NeogitOrg/neogit",
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",

            "nvim-telescope/telescope.nvim",
        },
        cmd = "Neogit",
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
        },
    },

    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            { "tpope/vim-dadbod" },
            { "kristijanhusak/vim-dadbod-completion" },
        },
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
        },
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
        end,
    },

    {
        "kristijanhusak/vim-dadbod-completion",
        dependencies = "vim-dadbod",
        ft = { "sql", "mysql", "plsql" },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "sql", "mysql", "plsql" },
                callback = function()
                    require("cmp").setup.buffer({
                        sources = {
                            { name = "vim-dadbod-completion" },
                            { name = "buffer" },
                        },
                    })
                end,
            })
        end,
    },
}
