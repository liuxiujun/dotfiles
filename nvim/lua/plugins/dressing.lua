--------------------------------------------------------------------------------
-- 插件名称：stevearc/dressing.nvim
-- 功能用途：统一接管 Neovim 的微型 UI 表单（接管 vim.ui.input 与 vim.ui.select）
--   1. grn (<leader>cr) 重命名：在光标处弹出圆角悬浮卡片
--   2. gra (<leader>ca) 快速修复：通过 Telescope 下拉式卡片展示修复选项
--------------------------------------------------------------------------------
return {
	"stevearc/dressing.nvim",
	event = "VeryLazy",
	opts = function()
		return {
			input = {
				enabled = true,
				default_prompt = "➤ Rename",
				title_pos = "left",
				start_in_insert = true,
				border = "rounded",
				relative = "cursor", -- 浮动卡片直接出现在光标所在变量处
				prefer_width = 30,
				max_width = { 140, 0.9 },
				min_width = { 20, 0.2 },
			},
			select = {
				enabled = true,
				backend = { "telescope", "builtin" }, -- 优先使用 Telescope 渲染选项列表
				telescope = require("telescope.themes").get_dropdown({}),
			},
		}
	end,
}
