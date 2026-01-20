local M = {}

M.setup = function()
    -- Navigate diagnostics
    vim.keymap.set(
        "n",
        "[d",
        vim.diagnostic.goto_prev,
        { desc = "Previous diagnostic" }
    )
    vim.keymap.set(
        "n",
        "]d",
        vim.diagnostic.goto_next,
        { desc = "Next diagnostic" }
    )

    -- Show diagnostic in float window
    vim.keymap.set(
        "n",
        "<leader>de",
        vim.diagnostic.open_float,
        { desc = "Show diagnostic" }
    )

    -- Open all diagnostics in quickfix
    vim.keymap.set(
        "n",
        "<leader>dq",
        vim.diagnostic.setloclist,
        { desc = "Diagnostic quickfix" }
    )

    -- Copy diagnostic message
    vim.keymap.set("n", "<leader>dy", function()
        local diagnostics =
            vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
        if #diagnostics > 0 then
            local messages = {}
            for _, diag in ipairs(diagnostics) do
                local source = diag.source and ("[" .. diag.source .. "] ")
                    or ""
                table.insert(messages, source .. diag.message)
            end
            local text = table.concat(messages, "\n\n")
            vim.fn.setreg("+", text)
            vim.notify("✓ Diagnostic copied!", vim.log.levels.INFO)
        else
            vim.notify("No diagnostic here", vim.log.levels.WARN)
        end
    end, { desc = "Copy diagnostic" })

    vim.keymap.set("n", "<leader>dd", function()
        vim.diagnostic.open_float(nil, {
            scope = "cursor",
            focusable = true,
            border = "rounded",
            header = "Diagnostic Details",
            source = "always",
            format = function(diagnostic)
                local source = diagnostic.source
                        and ("[" .. diagnostic.source .. "] ")
                    or ""
                return source .. diagnostic.message
            end,
        })
    end, { desc = "Diagnostic details" })
end

return M
