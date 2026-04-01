-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = ","

-- Hint: use `:h <option>` to figure out the meaning if needed
vim.opt.clipboard = "unnamedplus" -- use system clipboard

-- File Format
vim.opt.fileformat = "unix"                 -- 新建文件默认保存为 Unix 格式（LF）
vim.opt.fileformats = "unix,dos,mac"        -- 打开文件时自动检测行尾，优先当作 Unix 格式处理

-- Set Encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = "utf-8,gbk,gb18030,latin1,ucs-bom"

-- 设置代码折叠
vim.opt.foldmethod = "indent"
-- vim.opt.foldlevel = 99
-- vim.opt.foldnestmax = 5
-- vim.opt.foldcolumn = "1"
-- vim.opt.foldenable = true

local system = require("config.system");

if system.is_windows or system.is_wsl then
    -- print("You're in Windows/WSL2!")
    -- Windows 宿主机使用scoop安装win32yank
    vim.g.clipboard = {
        name = "win32yank",
        copy = {
            ["+"] = "win32yank.exe -i --crlf",
            ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "win32yank.exe -o --lf",
            ["*"] = "win32yank.exe -o --lf",
        },
        cache_enabled = 0,
    }
    -- vim.notify("📋 Clipboard set for Windows/WSL", vim.log.levels.INFO)
end
-- set terminal
if system.is_windows then
    vim.opt.shell = "pwsh"
    vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
    vim.opt.shellquote = ""
    vim.opt.shellxquote = ""
end

-- if system.is_arm then
--     print("Running on ARM architecture")
-- elseif system.is_amd64 then
--     print("Running on AMD64 architecture");
-- elseif system.is_i386 then
--     print("Running on i386 architecture");
--end

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.mouse = "a" -- allow the mouse to be used in Nvim

-- Tab
vim.opt.tabstop = 4      -- number of visual spaces per TAB
vim.opt.softtabstop = 4  -- number of spacesin tab when editing
vim.opt.shiftwidth = 4   -- insert 4 spaces on a tab
vim.opt.expandtab = true -- tabs are spaces, mainly because of python

-- UI config
vim.opt.number = true          -- show absolute number
vim.opt.relativenumber = false -- add numbers to each line on the left side
vim.opt.cursorline = true      -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true      -- open new vertical split bottom
vim.opt.splitright = true      -- open new horizontal splits right
vim.opt.termguicolors = true        -- enabl 24-bit RGB color in the TUI
vim.opt.showmode = false       -- we are experienced, wo don't need the "-- INSERT --" mode hint

-- Searching
vim.opt.incsearch = true  -- search as characters are entered
vim.opt.hlsearch = false  -- do not highlight matches
vim.opt.ignorecase = true -- ignore case in searches by default
vim.opt.smartcase = true  -- but make it case sensitive if an uppercase is entered

-- For nvim-tree
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

if vim.g.neovide then
  -- 设置一个初始缩放因子，例如 0.85，可以根据实际效果微调
  vim.g.neovide_scale_factor = 0.85

  -- 添加快捷键，方便随时缩放 [citation:6]
  local function set_scale(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
    -- 强制重绘，让缩放立即生效
    vim.api.nvim_command('redraw!')
  end

  vim.keymap.set({ "n", "v" }, "<C-=>", function() set_scale(1.1) end, { desc = "Increase Neovide scale" })
  vim.keymap.set({ "n", "v" }, "<C-->", function() set_scale(0.9) end, { desc = "Decrease Neovide scale" })
  vim.keymap.set({ "n", "v" }, "<C-0>", function() vim.g.neovide_scale_factor = 1.0; vim.api.nvim_command('redraw!') end, { desc = "Reset Neovide scale" })

end
