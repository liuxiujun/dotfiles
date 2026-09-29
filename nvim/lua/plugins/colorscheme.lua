--------------------------------------------------------------------------------
-- 插件名称：folke/tokyonight.nvim
-- 功能用途：全局配色主题（全插件原生适配，开箱即用）
--------------------------------------------------------------------------------
-- return {
-- 	"folke/tokyonight.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	opts = {
-- 		style = "night", -- 可选："night" (深邃黑蓝) | "storm" (柔和灰蓝) | "moon" (暗紫蓝) | "day" (亮色)
-- 		-- UI 边框、弹窗、状态栏 100% 使用 TokyoNight 原生设计；
-- 		-- 仅将代码语法高亮映射为 Sublime Text (Monokai) 经典高对比度配色（不需要时注释掉 on_highlights 即可）
-- 		on_highlights = function(hl, c)
-- 			local sublime = {
-- 				pink = "#f92672", -- 关键字 / 运算符
-- 				green = "#a6e22e", -- 函数定义 / 类装饰器
-- 				aqua = "#66d9ef", -- 函数调用 / 类型
-- 				yellow = "#e6db74", -- 字符串
-- 				purple = "#ae81ff", -- 数字 / 布尔 / 常量
-- 				orange = "#fd971f", -- 函数参数
-- 			}
-- 			-- 1. 关键字与运算符 -> 玫瑰品红
-- 			hl.Statement = { fg = sublime.pink }
-- 			hl.Keyword = { fg = sublime.pink, italic = true }
-- 			hl["@keyword"] = { fg = sublime.pink, italic = true }
-- 			hl["@keyword.function"] = { fg = sublime.aqua, italic = true }
-- 			hl.Operator = { fg = sublime.pink }
-- 			hl["@operator"] = { fg = sublime.pink }
-- 			-- 2. 函数定义(绿) 与 函数调用/类型(青)
-- 			hl.Function = { fg = sublime.green }
-- 			hl["@function.call"] = { fg = sublime.aqua }
-- 			hl["@function.method.call"] = { fg = sublime.aqua }
-- 			hl.Type = { fg = sublime.aqua, italic = true }
-- 			hl["@type.builtin"] = { fg = sublime.aqua, italic = true }
-- 			-- 3. 字符串(暖黄)、数字/布尔/常量(亮紫)、参数(亮橙)
-- 			hl.String = { fg = sublime.yellow }
-- 			hl.Number = { fg = sublime.purple }
-- 			hl.Boolean = { fg = sublime.purple }
-- 			hl.Constant = { fg = sublime.purple }
-- 			hl["@constant.builtin"] = { fg = sublime.purple }
-- 			hl["@variable.parameter"] = { fg = sublime.orange, italic = true }
--
-- 			-- 可选：Borderless Telescope（无边框色块风格）
-- 			local prompt = "#2d3149"
-- 			hl.TelescopeNormal = {
-- 				bg = c.bg_dark,
-- 				fg = c.fg_dark,
-- 			}
-- 			hl.TelescopeBorder = {
-- 				bg = c.bg_dark,
-- 				fg = c.bg_dark,
-- 			}
-- 			hl.TelescopePromptNormal = {
-- 				bg = prompt,
-- 			}
-- 			hl.TelescopePromptBorder = {
-- 				bg = prompt,
-- 				fg = prompt,
-- 			}
-- 			hl.TelescopePromptTitle = {
-- 				bg = prompt,
-- 				fg = "#2C94DD",
-- 			}
-- 			hl.TelescopePreviewTitle = {
-- 				bg = c.bg_dark,
-- 				fg = c.bg_dark,
-- 			}
-- 			hl.TelescopeResultsTitle = {
-- 				bg = c.bg_dark,
-- 				fg = c.bg_dark,
-- 			}
-- 		end,
-- 	},
-- 	config = function(_, opts)
-- 		require("tokyonight").setup(opts)
-- 		vim.cmd.colorscheme("tokyonight")
-- 	end,
-- }

return {
	"wtfox/luna.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		vim.cmd.colorscheme("luna")
	end,
}
