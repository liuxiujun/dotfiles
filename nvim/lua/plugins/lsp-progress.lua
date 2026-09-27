--------------------------------------------------------------------------------
-- 插件名称：linrongbin16/lsp-progress.nvim
-- 功能用途：LSP 状态与加载进度组件（集成在 lualine 状态栏中，显示当前挂载的 LSP 名称与后台索引进度）
--------------------------------------------------------------------------------
return {
	{
		"linrongbin16/lsp-progress.nvim",
		config = function()
			require("lsp-progress").setup()
		end,
	},
}
