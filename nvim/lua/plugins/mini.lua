--------------------------------------------------------------------------------
-- 插件名称：echasnovski/mini.* (mini.icons / mini.pairs / mini.diff)
-- 功能用途：轻量级现代化基础套件：
--   1. mini.icons：全项目统一图标引擎（原生支持 snacks，并自动兼容 lualine / bufferline）
--   2. mini.pairs：自动括号/引号配对（替代 nvim-autopairs）
--   3. mini.diff ：Git 行内差异竖线标记与 Hunk 操作（替代 gitsigns.nvim，联动 snacks.statuscolumn）
-- 常用按键：]h / [h (跳至上/下一处 Git 改动)、gh / gH (暂存/回滚改动块)、<leader>go (展开行内 Diff 对比)
--------------------------------------------------------------------------------
return {
	-- 1. 全局图标库（替代 nvim-web-devicons）
	{
		"echasnovski/mini.icons",
		lazy = true,
		opts = {},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
		config = function(_, opts)
			require("mini.icons").setup(opts)
			MiniIcons.mock_nvim_web_devicons()
		end,
	},

	-- 2. 自动括号与引号配对（替代 windwp/nvim-autopairs）
	{
		"echasnovski/mini.pairs",
		event = "InsertEnter",
		opts = {
			modes = { insert = true, command = false, terminal = false },
		},
	},

	-- 3. Git 行内差异标记与预览（替代 lewis6991/gitsigns.nvim）
	{
		"echasnovski/mini.diff",
		event = "VeryLazy",
		opts = {
			view = {
				style = "sign",
				signs = {
					add = "▎",
					change = "▎",
					delete = "",
				},
			},
		},
		keys = {
			{
				"<leader>go",
				function()
					require("mini.diff").toggle_overlay(0)
				end,
				desc = "Toggle Git diff overlay (mini.diff)",
			},
		},
	},
}
