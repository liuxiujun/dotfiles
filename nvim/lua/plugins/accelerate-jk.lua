-- speeds up vertical navigation with j and k (Pure Lua implementation)
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
