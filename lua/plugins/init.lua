return {

    {
        "nvim-treesitter/nvim-treesitter",
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
        "NStefan002/screenkey.nvim",
        cmd = "Screenkey",
        version = "*",
        opts = {
            win_opts = {
                relative = "editor",
                anchor = "NE", -- Top right corner
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
    },

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
            -- Menu
            {
                "<leader>a",
                function()
                    local harpoon = require("harpoon")
                    harpoon.ui:toggle_quick_menu(harpoon:list())
                end,
                desc = "Harpoon: Menu",
            },
            -- Remove current file ✅
            {
                "<leader>mr",
                function()
                    require("harpoon"):list():remove()
                    vim.notify("✓ Removed!", vim.log.levels.INFO)
                end,
                desc = "Harpoon: Remove current file",
            },
            -- Clear all marks ✅
            {
                "<leader>mc",
                function()
                    require("harpoon"):list():clear()
                    vim.notify("✓ Cleared all!", vim.log.levels.WARN)
                end,
                desc = "Harpoon: Clear all",
            },
            -- Jump to files
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

            -- Add prettierd formatting
            table.insert(
                opts.sources,
                null_ls.builtins.formatting.prettierd.with({
                    filetypes = {
                        "javascript",
                        "typescript",
                        "css",
                        "html",
                        "json",
                        "yaml",
                        "markdown",
                    },
                })
            )

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
                            vim.lsp.buf.format({ bufnr = bufnr })
                        end,
                    })
                end
            end

            return opts
        end,
    },
    {
        "sindrets/diffview.nvim",
        lazy = false, -- Load at startup instead of lazy loading
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("diffview").setup()
        end,
    },

    -- SQL Syntax & Formatting
    {
        "tpope/vim-dadbod",
        cmd = "DB",
    },

    -- Database UI
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

    -- SQL completion
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
