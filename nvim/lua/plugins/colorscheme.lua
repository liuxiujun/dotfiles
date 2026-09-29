--------------------------------------------------------------------------------
-- 插件名称：folke/tokyonight.nvim
-- 功能用途：全局配色主题（全插件原生适配，开箱即用）
--------------------------------------------------------------------------------
return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		style = "night", -- 可选："night" (深邃黑蓝) | "storm" (柔和灰蓝) | "moon" (暗紫蓝) | "day" (亮色)
	},
	config = function(_, opts)
		require("tokyonight").setup(opts)
		vim.cmd.colorscheme("tokyonight")
	end,
}
