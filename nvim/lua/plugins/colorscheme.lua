--------------------------------------------------------------------------------
-- 插件名称：全局配色主题
-- 使用方式：保留想要启用的主题块取消注释，其余主题块注释掉即可
--------------------------------------------------------------------------------

-- 1. TokyoNight（Folke 官方主题，与 snacks / flash / which-key 同作者，适配度天花板）
return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		style = "night", -- 可选："night" (深黑蓝) | "storm" (蓝灰) | "moon" (暗紫蓝) | "day" (亮色)
	},
	config = function(_, opts)
		require("tokyonight").setup(opts)
		vim.cmd.colorscheme("tokyonight")
	end,
}

-- -- 2. 你原本的经典 Monokai（tanvirtin/monokai.nvim）
-- return {
-- 	"tanvirtin/monokai.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		-- 可选："monokai" | "monokai_pro" | "monokai_soda" | "monokai_ristretto"
-- 		vim.cmd.colorscheme("monokai")
-- 	end,
-- }

-- -- 3. Sonokai（维护极活跃的现代高对比度 Monokai 衍生主题，由 gruvbox-material 作者打造）
-- return {
-- 	"sainnhe/sonokai",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		-- 可选风格："default" (经典 Monokai) | "shusia" (对应 Monokai Pro) | "andromeda" | "atlantis" | "maia" | "espresso"
-- 		vim.g.sonokai_style = "default"
-- 		vim.g.sonokai_better_performance = 1
-- 		vim.cmd.colorscheme("sonokai")
-- 	end,
-- }

-- -- 4. Catppuccin（社区人气第一，暖色柔和糖果色调）
-- return {
-- 	"catppuccin/nvim",
-- 	name = "catppuccin",
-- 	lazy = false,
-- 	priority = 1000,
-- 	opts = {
-- 		flavour = "mocha", -- 可选："mocha" (深暗暖黑) | "macchiato" | "frappe" | "latte" (亮色)
-- 		integrations = {
-- 			snacks = true,
-- 			blink_cmp = true,
-- 			flash = true,
-- 			mini = { enabled = true },
-- 			which_key = true,
-- 			lsp_trouble = true,
-- 			render_markdown = true,
-- 		},
-- 	},
-- 	config = function(_, opts)
-- 		require("catppuccin").setup(opts)
-- 		vim.cmd.colorscheme("catppuccin")
-- 	end,
-- }

-- -- 5. Kanagawa（日式浮世绘暖暗色调，低眩光极度护眼）
-- return {
-- 	"rebelot/kanagawa.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	opts = {
-- 		theme = "wave", -- 可选："wave" (经典暖暗) | "dragon" (深邃纯黑) | "lotus" (亮色)
-- 	},
-- 	config = function(_, opts)
-- 		require("kanagawa").setup(opts)
-- 		vim.cmd.colorscheme("kanagawa")
-- 	end,
-- }

-- -- 6. Rosé Pine（复古松木暗紫暖色调）
-- return {
-- 	"rose-pine/neovim",
-- 	name = "rose-pine",
-- 	lazy = false,
-- 	priority = 1000,
-- 	opts = {
-- 		variant = "main", -- 可选："main" (经典暗紫) | "moon" (偏冷深暗) | "dawn" (亮色)
-- 	},
-- 	config = function(_, opts)
-- 		require("rose-pine").setup(opts)
-- 		vim.cmd.colorscheme("rose-pine")
-- 	end,
-- }

-- -- 7. Nightfox（一套插件内置 7 种高质量现代主题，如夜狐 nightfox 与高对比纯黑 carbonfox）
-- return {
-- 	"EdenEast/nightfox.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		require("nightfox").setup({})
-- 		-- 可选："nightfox" | "carbonfox" (IBM 高对比纯黑) | "duskfox" | "nordfox" | "terafox"
-- 		vim.cmd.colorscheme("carbonfox")
-- 	end,
-- }
