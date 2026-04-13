-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Define common options
local opts = {
	noremap = true, -- non-recursive
	silent = true, -- do not show message
}

-----------------
-- Normal mode --
-----------------

-- Hint: see `:h vim.map.set()`
-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
-- delta: 2 lines
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- custom
vim.keymap.set("n", "<leader>s", ":w<CR>", { noremap = true, silent = true, desc="[S]ave" })
vim.keymap.set("n", "<leader>x", ":q<CR>", { noremap = true, silent = true, desc="Close" })
vim.keymap.set("n", "<leader>X", ":qa<CR>", { noremap = true, silent = true, desc="Close All" })

-- Overseer
vim.keymap.set("n", "<leader>rr", "<cmd>OverseerRun<cr>", { desc = "Overseer Run Task" })
vim.keymap.set("n", "<leader>rt", "<cmd>OverseerToggle<cr>", { desc = "Overseer Toggle" })
vim.keymap.set("n", "<leader>rc", "<cmd>OverseerRunCmd<cr>", { desc = "Overseer Run Custom Cmd" })
vim.keymap.set("n", "<leader>ra", "<cmd>OverseerRunAction<cr>", { desc = "Overseer Run Task Action" })
vim.keymap.set("n", "<leader>rq", "<cmd>OverseerQuickAction<cr>", { desc = "Overseer Quick Action" })

-- For flash.nvim
-- 1. Press `s` and type jump label
-- 2. Press `S` and type jump label for specefic selection based on tree-sitter.
--    You can also use `;` or `,` to increase/decrease the selection

-- For nvim-surround
--     Old text                    Command         New text
-- --------------------------------------------------------------------------------
--     surr*ound_words             ysiw)           (surround_words)
--     *make strings               ys$"            "make strings"
--     [delete ar*ound me!]        ds]             delete around me!
--     remove <b>HTML t*ags</b>    dst             remove HTML tags
--     'change quot*es'            cs'"            "change quotes"
--     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>

-- For diagnostic
vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, { noremap = true, silent = true, desc = "Previous diagnostic" } )
vim.keymap.set("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, { noremap = true, silent = true, desc = "Next error" } )
vim.keymap.set("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, { noremap = true, silent = true, desc = "Previous error" } )
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Show line diagnostics" } )
vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, { noremap = true, silent = true, desc = "Send diagnostics to loclist" } )

-- Manage Lsp 
vim.keymap.set("n", "<leader>lC", "<cmd>checkhealth vim.lsp<CR>", { noremap = true, silent = true, desc = "[C]heckhealth (LspInfo)" })
-- vim.keymap.set("n", "<leader>ls", "<cmd>LspStart<CR>", { noremap = true, silent = true, desc = "Start LSP server (if not started )" })
vim.keymap.set("n", "<leader>lR", 
    function() 
        local bufnr = vim.api.nvim_get_current_buf()
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            client:stop()
            vim.lsp.start(client.config, { bufnr = bufnr })
        end 
        vim.notify("LSP clients restarted", vmi.log.levels.INFO)
    end , { desc = "[R]estart LSP clients for current buffer" })
-- vim.keymap.set("n", "<leader>lS", "<cmd>LspStop<CR>", { noremap = true, silent = true, desc = "Stop LSP server" })
vim.keymap.set("n", "<leader>lL", "<cmd>lua vim.cmd('edit ' .. vim.lsp.get_log_path())<CR>", { noremap = true, silent = true, desc = "Show LSP [L]og" })
vim.keymap.set("n", "<leader>lM", "<cmd>Mason<CR>", { noremap = true, silent = true, desc = "Open [M]ason (LSP installer )" })

-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- For nvim-treesitter
-- 1. Press `gss` to intialize selection. (ss = start selection)
-- 2. Now we are in the visual mode.
-- 3. Press `gsi` to increment selection by AST node. (si = selection incremental)
-- 4. Press `gsc` to increment selection by scope. (sc = scope)
