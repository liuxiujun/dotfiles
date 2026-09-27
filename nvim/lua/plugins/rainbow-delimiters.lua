--------------------------------------------------------------------------------
-- 插件名称：HiPhish/rainbow-delimiters.nvim
-- 功能用途：彩虹括号（基于 Treesitter 为不同嵌套层级的 () [] {} 赋予高对比度色弱友好颜色）
--------------------------------------------------------------------------------
-- return {
--     "HiPhish/rainbow-delimiters.nvim",
--     dependencies = { "nvim-treesitter/nvim-treesitter" },
--     event = "BufReadPost",
-- }
-- 彩虹括号：色弱友好（Colorblind Friendly / Okabe-Ito）高对比度配置
return {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufReadPost",
    config = function()
        -- 1. 定义色弱友好的高对比度高亮组（采用经暗色底优化的 Okabe-Ito 方案）
        local function setup_cvd_highlights()
            local colors = {
                RainbowCvdSkyBlue   = { fg = "#56B4E9", bold = true }, -- 1: 天蓝（高亮冷色）
                RainbowCvdOrange    = { fg = "#E69F00", bold = true }, -- 2: 暖橙（明快暖色）
                RainbowCvdYellow    = { fg = "#F0E442", bold = true }, -- 3: 亮黄（极高明度）
                RainbowCvdBlue      = { fg = "#0072B2", bold = true }, -- 4: 宝蓝（深沉冷色）
                RainbowCvdPink      = { fg = "#CC79A7", bold = true }, -- 5: 玫粉（柔和暖色）
                RainbowCvdMintGreen = { fg = "#009E73", bold = true }, -- 6: 蓝绿（偏蓝的绿，避开红绿混淆）
            }

            for group, opts in pairs(colors) do
                vim.api.nvim_set_hl(0, group, opts)
            end
        end

        -- 2. 初始加载颜色
        setup_cvd_highlights()

        -- 3. 监听主题切换（防止切换 colorscheme 时自定义高亮被清空覆盖）
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("RainbowCvdHighlights", { clear = true }),
            callback = setup_cvd_highlights,
        })

        -- 4. 将自定义高亮组配置给 rainbow-delimiters
        vim.g.rainbow_delimiters = {
            strategy = {
                [""] = "rainbow-delimiters.strategy.global",
            },
            query = {
                [""] = "rainbow-delimiters",
                lua = "rainbow-blocks",
            },
            highlight = {
                "RainbowCvdSkyBlue",
                "RainbowCvdOrange",
                "RainbowCvdYellow",
                "RainbowCvdBlue",
                "RainbowCvdPink",
                "RainbowCvdMintGreen",
            },
        }
    end,
}
