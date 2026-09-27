--------------------------------------------------------------------------------
-- 插件名称：tanvirtin/monokai.nvim
-- 功能用途：全局配色主题（Monokai 暗色主题，设置最高优先级在启动时最先加载）
--------------------------------------------------------------------------------
-- return { "ellisonleao/gruvbox.nvim" }
-- return { "catppuccin/nvim", name = "catppuccin", priority = 1000 }
return {
    "tanvirtin/monokai.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        local colorscheme = "monokai"

        local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
        if not is_ok then
            vim.notify("colorscheme " .. colorscheme .. " not found!")
            return
        end
    end,
}
