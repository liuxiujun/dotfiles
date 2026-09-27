--------------------------------------------------------------------------------
-- 插件名称：lukas-reineke/indent-blankline.nvim
-- 功能用途：代码缩进对齐线（在每层缩进处显示垂直辅助线，直观展示代码块层级）
--------------------------------------------------------------------------------
return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPost", "BufNewFile" },
	main = "ibl",
	--@module "ibl"
	--@type ibl.config
	opts = {},
}
