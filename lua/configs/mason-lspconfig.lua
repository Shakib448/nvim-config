local lsp_configs = require("configs.lspconfig")

local servers_to_install = {
    "lua_ls",
    "clangd",
    "gopls",
    "ts_ls",
    "rust_analyzer",
}

require("mason-lspconfig").setup({
    ensure_installed = servers_to_install,
    automatic_installation = false,

    handlers = {
        -- Default handler
        function(server_name)
            local config = lsp_configs.servers[server_name] or {}

            -- Fallback to basic config if not defined
            if vim.tbl_isempty(config) then
                config = {
                    on_attach = require("nvchad.configs.lspconfig").on_attach,
                    on_init = require("nvchad.configs.lspconfig").on_init,
                    capabilities = require("nvchad.configs.lspconfig").capabilities,
                }
            end

            vim.lsp.config[server_name] = config
            vim.lsp.enable(server_name)
        end,
    },
})
local prisma_config = lsp_configs.servers.prismals
if prisma_config then
    vim.lsp.config.prismals = prisma_config
    vim.lsp.enable("prismals")
end
