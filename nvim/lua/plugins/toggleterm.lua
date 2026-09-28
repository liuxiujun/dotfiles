--------------------------------------------------------------------------------
-- 插件名称：akinsho/toggleterm.nvim
-- 功能用途：内置浮动终端管理（在编辑器中央一键呼出/隐藏 PowerShell 或默认终端会话）
-- 常用按键：<C-\> (开关浮动终端)、终端内按 <Esc> 或 jk 退回 Normal 模式
--------------------------------------------------------------------------------
return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        local is_ok, toggleterm = pcall(require, "toggleterm")
        if not is_ok then
            return
        end

        toggleterm.setup({
            size = 12,
            open_mapping = [[<C-\>]], -- how to open a new terminal
            hide_numbers = true,      -- hide the number column in toggleterm buffers
            close_on_exit = true,     -- close the terminal window when the process exits
            shell = function()
                if require("config.system").is_windows then
                    return "pwsh"
                else
                    return vim.o.shell
                end
            end,
            direction = "horizontal",
        })

        -- Define key mappings
        -- t: terminal mode
        vim.api.nvim_create_autocmd("TermOpen", {
            pattern = "term://*toggleterm#*",
            group = vim.api.nvim_create_augroup("toggleterm_keymaps", { clear = true }),
            callback = function()
                local opts = { noremap = true, buffer = 0 }
                -- Go back to the Normal model in terminal
                vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
                vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)

                vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
                vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
                vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
                vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)

                vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
            end,
        })
    end,
}
