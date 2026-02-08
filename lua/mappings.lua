require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Basic operations
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open Diffview" })
map("n", "<leader>gc", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" })
map(
    "n",
    "<leader>gf",
    "<cmd>DiffviewToggleFiles<cr>",
    { desc = "Toggle File Panel" }
)
map(
    "n",
    "<leader>gr",
    "<cmd>DiffviewRefresh<cr>",
    { desc = "Refresh Diffview" }
)

-- File History
map(
    "n",
    "<leader>gh",
    "<cmd>DiffviewFileHistory<cr>",
    { desc = "Repo History" }
)
map(
    "n",
    "<leader>gH",
    "<cmd>DiffviewFileHistory %<cr>",
    { desc = "Current File History" }
)
map(
    "v",
    "<leader>gh",
    ":'<,'>DiffviewFileHistory<cr>",
    { desc = "Selection History" }
)

-- Compare branches
map("n", "<leader>gm", "<cmd>DiffviewOpen main<cr>", { desc = "Diff vs main" })
map(
    "n",
    "<leader>gM",
    "<cmd>DiffviewOpen origin/main<cr>",
    { desc = "Diff vs origin/main" }
)
map(
    "n",
    "<leader>gD",
    "<cmd>DiffviewOpen develop<cr>",
    { desc = "Diff vs develop" }
)

-- Compare commits
map(
    "n",
    "<leader>gp",
    "<cmd>DiffviewOpen HEAD~1<cr>",
    { desc = "Diff vs previous commit" }
)
map(
    "n",
    "<leader>gs",
    "<cmd>DiffviewOpen --staged<cr>",
    { desc = "Diff staged changes" }
)

-- MERGE CONFLICT RESOLUTION (Most Important!)
map(
    "n",
    "<leader>gx",
    "<cmd>DiffviewOpen<cr>",
    { desc = "Open merge conflicts" }
)

-- Accept changes during merge (3-way diff)
map(
    "n",
    "<leader>co",
    "<cmd>diffget //2<cr>",
    { desc = "Accept OURS (Left/Current)" }
)
map(
    "n",
    "<leader>ct",
    "<cmd>diffget //3<cr>",
    { desc = "Accept THEIRS (Right/Incoming)" }
)
map(
    "n",
    "<leader>cb",
    ":<C-u>diffget //2 | diffget //3<cr>",
    { desc = "Accept BOTH changes" }
)

-- Navigate between conflicts
map("n", "]x", "/^<<<<<<< <cr>", { desc = "Next conflict marker" })
map("n", "[x", "?^<<<<<<< <cr>", { desc = "Previous conflict marker" })

-- Focus toggle
map(
    "n",
    "<leader>gt",
    "<cmd>DiffviewFocusFiles<cr>",
    { desc = "Focus file panel" }
)

-- Interactive branch compare
map("n", "<leader>gb", function()
    vim.ui.input({ prompt = "Branch to compare: " }, function(branch)
        if branch then
            vim.cmd("DiffviewOpen " .. branch)
        end
    end)
end, { desc = "Diff vs branch" })

map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
