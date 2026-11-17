--------------------------------------------------------------------------------
-- 插件名称：Tree-sitter 语法树套件
-- 包含组件：
--   1. nvim-treesitter             语法树解析核心（提供精准语法高亮、代码折叠与缩进计算）
--   2. nvim-treesitter-textobjects 语法文本对象（提供 am/im/ac/ic 选中函数/类，以及 [m/]m 函数间跳转）
--   3. nvim-treesitter-context     顶部上下文吸顶（滚动长函数时在窗口顶部固定显示当前所属函数签名）
--   4. nvim-ts-autotag             HTML/JSX 标签自动闭合与同步重命名
--------------------------------------------------------------------------------
-- todo:
--  nvim-treesitter-refactor 智能代码重构
--  nvim-ts-context-commentstring 智能注释， 根据光标所在位置（代码中还是字符串里），自动设置正确的注释符号

return {
	-- 1. treesitter
	-- need to run: npm install -g tree-sitter-cli
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(details)
					local bufnr = details.buf
					if not pcall(vim.treesitter.start, bufnr) then
						return
					end
					vim.wo.foldmethod = "expr"
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
			vim.treesitter.language.register("markdown", "blink-cmp-documentation")
		end,
		dependencies = {},
	},
	-- 2. treesitter-textobjects：函数/类文本对象与跳转
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		event = "BufReadPost",
		config = function()
			require("nvim-treesitter-textobjects").setup({
				move = { set_jumps = true },
			})

			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")

			-- 文本对象：a(含边界)/i(内部) + m(函数)/c(类)
			vim.keymap.set({ "x", "o" }, "am", function() select.select_textobject("@function.outer", "textobjects") end, { desc = "Around function" })
			vim.keymap.set({ "x", "o" }, "im", function() select.select_textobject("@function.inner", "textobjects") end, { desc = "Inside function" })
			vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end, { desc = "Around class" })
			vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end, { desc = "Inside class" })

			-- 函数间跳转：基于语法树，覆盖内置的正则版本 ]m/]M/[m/[M
			vim.keymap.set({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next function start" })
			vim.keymap.set({ "n", "x", "o" }, "]M", function() move.goto_next_end("@function.outer", "textobjects") end, { desc = "Next function end" })
			vim.keymap.set({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Previous function start" })
			vim.keymap.set({ "n", "x", "o" }, "[M", function() move.goto_previous_end("@function.outer", "textobjects") end, { desc = "Previous function end" })
		end,
	},
	-- 3. treesitter-context
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufRead",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			event = "BufRead",
		},
		opts = {
			multiwindow = true,
		},
	},
	-- 4. autotag
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = true,
	},
}
