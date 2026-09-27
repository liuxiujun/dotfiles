--------------------------------------------------------------------------------
-- 插件名称：nvim-telescope/telescope.nvim (依赖 plenary.nvim)
-- 功能用途：全局模糊搜索与预览器（负责找文件、全局文本搜索，并在 autocmds.lua 中接管所有 LSP 跳转与选择框）
-- 常用按键：<leader>ff (找文件)、<leader>fg (全局搜文本)、<leader>/ (当前文件搜索)、<leader>fr (最近文件)
--------------------------------------------------------------------------------
return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		cmd = "Telescope",
		keys = {
			{
				"<leader>ff",
				function()
					-- use a previewer that doesn't show each file's contents
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
