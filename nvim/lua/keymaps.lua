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
vim.keymap.set("n", "<leader>s", ":w<CR>", opts)
vim.keymap.set("n", "<leader>x", ":q<CR>", opts)
vim.keymap.set("n", "<leader>X", ":qa<CR>", opts)
vim.keymap.set("n", "<leader>1", "1gt", opts)
vim.keymap.set("n", "<leader>2", "2gt", opts)
vim.keymap.set("n", "<leader>3", "3gt", opts)
vim.keymap.set("n", "<leader>4", "4gt", opts)
vim.keymap.set("n", "<leader>5", "5gt", opts)
vim.keymap.set("n", "<leader>6", "6gt", opts)
vim.keymap.set("n", "<leader>7", "7gt", opts)
vim.keymap.set("n", "<leader>8", "8gt", opts)
vim.keymap.set("n", "<leader>9", "9gt", opts)

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
-- 5. Press `gsd` to decrement selection. (sd = selection decrement)
