-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local system = require("config.system");

vim.g.mapleader = ","


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

-- Clipboard
-- Hint: use `:h <option>` to figure out the meaning if needed
vim.opt.clipboard = "unnamedplus" -- use system clipboard

-- for Windows WSL
if system.is_windows or system.is_wsl then
    if vim.fn.executable("win32yank.exe") == 1 then
        vim.g.clipboard = {
            name = "win32yank",
            copy = { ["+"] = "win32yank.exe -i --crlf", ["*"] = "win32yank.exe -i --crlf" },
            paste = { ["+"] = "win32yank.exe -o --lf", ["*"] = "win32yank.exe -o --lf" },
            cache_enabled = 0,
        }
    else 
        vim.notify("📋 win32yank not found, clipboard may not work on Windows/WSL", vim.log.levels.INFO)
    end
end

-- set terminal (windows)
if system.is_windows then
    vim.opt.shell = "pwsh"
    vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
    vim.opt.shellquote = ""
    vim.opt.shellxquote = ""
end

-- Diagnostic 
-- :help vim.diagnostic.Opts
vim.diagnostic.config({
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    underline = { severity = vim.diagnostic.severity.ERROR },
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ", -- 这里配置“错误”的图标，需要nerd font字体
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
        },
    },
    virtual_text = {
        source = "if_many",
        spacing = 2,
        format = function(diagnostic)
            local diagnostic_message = {
                [vim.diagnostic.severity.error] = diagnostic.message,
                [vim.diagnostic.severity.warn] = diagnostic.message,
                [vim.diagnostic.severity.info] = diagnostic.message,
                [vim.diagnostic.severity.hint] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
        end,
    },
})

-- Mouse 
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


-- for neovide 
if vim.g.neovide then
    vim.g.neovide_scale_factor = 0.85

    -- 添加快捷键，方便随时缩放 [citation:6]
    local function set_scale(delta)
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
        -- 强制重绘，让缩放立即生效
        vim.api.nvim_command('redraw!')
    end

    vim.keymap.set(
        { "n", "v" }, 
        "<C-=>", 
        function() set_scale(1.1) end, 
        { desc = "Increase Neovide scale" }
    )
    vim.keymap.set(
        { "n", "v" }, 
        "<C-->", 
        function() set_scale(0.9) end, 
        { desc = "Decrease Neovide scale" }
    )
    vim.keymap.set(
        { "n", "v" }, 
        "<C-0>", 
        function() 
            vim.g.neovide_scale_factor = 1.0; 
            vim.api.nvim_command('redraw!') 
        end, 
        { desc = "Reset Neovide scale" }
    )

end
