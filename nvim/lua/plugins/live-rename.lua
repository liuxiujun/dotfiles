--------------------------------------------------------------------------------
-- 插件名称：saecki/live-rename.nvim
-- 功能用途：行内实时模态重命名（在光标处弹出浮动编辑框，支持 Vim 完整 Normal/Insert 模态并实时预览引用）
-- 常用按键：<leader>cr / grn (行内就地重命名当前变量)
--------------------------------------------------------------------------------
return {
	"saecki/live-rename.nvim",
	opts = {
		prepare_rename = true,
		request_timeout = 2000,
		show_other_ocurrences = true,
		use_patterns = true,
		keys = {
			submit = {
				{ "n", "<cr>" },
				{ "v", "<cr>" },
				{ "i", "<cr>" },
			},
			cancel = {
				{ "n", "<esc>" },
				{ "n", "q" },
				{ "i", "<C-c>" },
			},
		},
		hl = {
			current = "CurSearch",
			others = "Search",
		},
	},
}
