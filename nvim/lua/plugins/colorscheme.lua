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
