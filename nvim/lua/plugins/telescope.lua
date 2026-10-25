--------------------------------------------------------------------------------
-- 插件名称：nvim-telescope/telescope.nvim (依赖 plenary.nvim)
-- 功能用途：全局模糊搜索与代码上下文预览器（找文件、全局搜文本、查全工程引用）
-- 常用按键：<leader>ff (找文件)、<leader>fg (全局搜文本)、<leader>/ (当前文件搜索)、<leader>fr (最近文件)
--------------------------------------------------------------------------------
local function get_find_command()
	if vim.fn.executable("fd") == 1 then
		return { "fd", "--type", "f", "--strip-cwd-prefix", "--hidden", "--exclude", ".git" }
	elseif vim.fn.executable("fdfind") == 1 then
		return { "fdfind", "--type", "f", "--strip-cwd-prefix", "--hidden", "--exclude", ".git" }
	elseif vim.fn.executable("rg") == 1 then
		return { "rg", "--files", "--hidden", "--glob", "!.git/*" }
	end
	return nil
end

return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = vim.fn.executable("make") == 1 and "make"
					or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
				cond = function()
					return vim.fn.executable("cmake") == 1 or vim.fn.executable("make") == 1
				end,
			},
		},
		event = "VeryLazy",
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					-- 1. 过滤巨型无用目录（避免把 .git/objects、node_modules、缓存等成千上万个文件喂给 Lua 排序器）
					file_ignore_patterns = {
						"^%.git[\\/]",
						"%.git[\\/]",
						"^node_modules[\\/]",
						"node_modules[\\/]",
						"^%.cache[\\/]",
						"%.cache[\\/]",
						"^target[\\/]",
						"^vendor[\\/]",
						"^dist[\\/]",
						"^build[\\/]",
						"%.lock$",
					},
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
				pickers = {
					find_files = {
						-- 优先使用原生 fd 或 rg（Windows 下杜绝降级至极慢的 where /r . *）
						find_command = get_find_command(),
					},
				},
			})

			-- 尝试加载 fzf-native C 扩展提升数十倍过滤速度
			pcall(telescope.load_extension, "fzf")
		end,
		cmd = "Telescope",
		keys = {
			{
				"<leader>ff",
				function()
					-- 使用无文件全预览的下拉卡片模式
					local previewer = require("telescope.themes").get_dropdown({
						previewer = false,
						find_command = get_find_command(),
					})
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
