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
				get_config = function(opts)
					-- nvim-tree 的增删改查交互（如 y/N 确认、完整路径新建）专为命令行设计，
					-- 若强行被浮动弹窗拦截会因默认参数预填(如默认填n导致删不掉)和狭窄侧边栏冲突，
					-- 因此在 nvim-tree 中自动回退到原生命令行输入，彻底恢复稳定交互
					if vim.bo.filetype == "NvimTree" then
						return { enabled = false }
					end
					return {}
				end,
			},
			select = {
				enabled = true,
				backend = { "telescope", "builtin" }, -- 优先使用 Telescope 渲染选项列表
				telescope = require("telescope.themes").get_dropdown({}),
				get_config = function(opts)
					if vim.bo.filetype == "NvimTree" then
						return { enabled = false }
					end
					return {}
				end,
			},
		}
	end,
}
