--------------------------------------------------------------------------------
-- 插件名称：kylechui/nvim-surround
-- 功能用途：成对包裹符号快速增删改（快速操作单词或文本块外围的括号、引号、HTML 标签）
-- 常用按键：ysiw" (给单词加引号)、cs"' (双引号改单引号)、ds" (删除外围引号)
--------------------------------------------------------------------------------
return {
	"kylechui/nvim-surround",
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	-- You can use the VeryLazy event for things that can
	-- load later and are not important for the initial UI
	event = "VeryLazy",
	config = function()
		require("nvim-surround").setup({
			-- Configuration here, or leave empty to use defaults
		})
	end,
}
