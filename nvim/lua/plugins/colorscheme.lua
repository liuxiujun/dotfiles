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
			-- 保留作者原生的「无边框纯色块」设计，仅在同色系下推高弹窗背景明度，与底层代码 (#080c10) 拉开清晰层次
			scheme = {
				ui_bg = "#181b2e", -- 通用浮动窗口底色（原为 #131426）
				picker_bg = "#181b2e", -- Telescope 列表区底色（原为 #0f1018，和底层 #080c10 几乎一样黑）
				telescope_bg = "#181b2e",
				picker_prompt = "#232742", -- Telescope 输入框底色（原为 #131426，提亮后形成上亮下暗的立体层次）
				telescope_prompt = "#232742",
			},
			custom_hlgroups = {
				-- 右侧预览区（原主题直接用了底层代码背景 #080c10，改为独立深蓝底色块）
				TelescopePreviewNormal = { bg = "#141726" },
				TelescopePreviewBorder = { fg = "#141726", bg = "#141726" },
				TelescopePreviewTitle = { fg = "#e373cd", bg = "#141726", bold = true },
				-- 列表选中行：在 #181b2e 面板上进一步提亮选中条
				TelescopeSelection = { bg = "#282e4d", fg = "#ffffff", bold = true },
			},
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
