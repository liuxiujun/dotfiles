-- return {
--     "ojroques/nvim-osc52",
--     event = "VeryLazy",
--     config = function()
--         require("osc52").setup({
--             max_length = 0,
--             trim = false,
--             silent = false,
--         })
--
--         -- 自动复制到本地剪贴板
--         vim.api.nvim_create_autocmd("TextYankPost", {
--             callback = function()
--                 if vim.v.event.operator == "y" and vim.v.event.regname == "+" then
--                     require("osc52").copy_register("+")
--                 end
--             end,
--         })
--     end,
-- }
-- lazy.nvim 示例
return {
    "ojroques/nvim-osc52",
    event = "VeryLazy",
    config = function()
        require("osc52").setup({
            max_length = 0,
            trim = false,
            silent = false,
        })

        -- 当使用 `"+y` 或默认 `y` 时自动触发复制
        vim.api.nvim_create_autocmd("TextYankPost", {
            callback = function()
                if vim.v.event.operator == "y" then
                    require("osc52").copy_register(vim.v.event.regname == "" and '"' or vim.v.event.regname)
                end
            end,
        })
    end,
}
