--------------------------------------------------------------------------------
-- 插件名称：nvim-telescope/telescope.nvim (依赖 plenary.nvim)
-- 功能用途：全局模糊搜索与代码上下文预览器（找文件、全局搜文本、查全工程引用）
-- 常用按键：<leader>ff (找文件)、<leader>fg (全局搜文本)、<leader>/ (当前文件搜索)、<leader>fr (最近文件)
--------------------------------------------------------------------------------
return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		event = "VeryLazy",
		opts = function()
			local actions = require("telescope.actions")
			return {
				defaults = {
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next, -- 插入模式下 Ctrl+j 向下移动
							["<C-k>"] = actions.move_selection_previous, -- 插入模式下 Ctrl+k 向上移动
						},
						n = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
						},
					},
				},
			}
		end,
		cmd = "Telescope",
		keys = {
			{
				"<leader>ff",
				function()
					-- 使用无文件全预览的下拉卡片模式
					local previewer = require("telescope.themes").get_dropdown({ previewer = false })
					require("telescope.builtin").find_files(previewer)
				end,
				desc = "[f]ind [f]iles",
			},
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "[f]ind with [g]rep in directory" },
			{ "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find in buffer" },
			{ "<leader>fc", "<cmd>Telescope treesitter<CR>", desc = "[f]ind [c]ode object" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "[f]ind [r]ecently-opened files" },
		},
	},
}
