--------------------------------------------------------------------------------
-- 插件名称：ofirgall/ofirkai.nvim
-- 功能用途：全局配色主题（高度还原 Sublime Text 的 Monokai 配色，当前启用 dark_blue 风格）
--------------------------------------------------------------------------------
return {
	"ofirgall/ofirkai.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("ofirkai").setup({
			-- 可选风格：
			--   nil         : 默认经典 Sublime Text Monokai 暖黑底
			--   "dark_blue" : 深蓝暗底风格 (Sublime Text + Dark Blue)
			theme = "dark_blue",
		})
	end,
}

-- 备选主题：loctvl842/monokai-pro.nvim
-- return {
-- 	"loctvl842/monokai-pro.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		require("monokai-pro").setup({
-- 			filter = "classic", -- "pro" | "classic" | "octagon" | "machine" | "ristretto" | "spectrum" | "light"
-- 			devicons = true,
-- 		})
-- 		vim.cmd.colorscheme("monokai-pro")
-- 	end,
-- }
