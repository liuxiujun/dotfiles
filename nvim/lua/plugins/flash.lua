--------------------------------------------------------------------------------
-- 插件名称：folke/flash.nvim
-- 功能用途：全屏极速光标跳转与语法树节点快速选中（替代原 hop.nvim）
-- 常用按键：s (输入目标字符+标签快速跳转)、S (按 Treesitter 语法层级一键高亮选中代码块)
--------------------------------------------------------------------------------
return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {},
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash Jump",
		},
		{
			"S",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter (选中语法块)",
		},
		{
			"r",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Remote Flash (隔空操作后光标回原位)",
		},
		{
			"R",
			mode = { "o", "x" },
			function()
				require("flash").treesitter_search()
			end,
			desc = "Treesitter Search (搜索并选中语法块)",
		},
		-- 兼容原有 hop 肌肉记忆快捷键
		{
			"<leader><leader>w",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash Jump",
		},
		{
			"<leader><leader>b",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash Jump",
		},
	},
}
