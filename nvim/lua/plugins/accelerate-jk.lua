--------------------------------------------------------------------------------
-- 插件名称：rainbowhxch/accelerated-jk.nvim
-- 功能用途：垂直移动加速（长按 j / k 时自动按阶梯曲线加快光标上下移动速度）
--------------------------------------------------------------------------------
return {
	{
		"rainbowhxch/accelerated-jk.nvim",
		keys = {
			{ "j", "<Plug>(accelerated_jk_gj)", mode = "n" },
			{ "k", "<Plug>(accelerated_jk_gk)", mode = "n" },
		},
		opts = {
			mode = "time_driven",
			enable_deceleration = false,
			acceleration_motions = {},
			acceleration_limit = 150,
			acceleration_table = { 7, 13, 20, 33, 53, 86 },
		},
	},
}
