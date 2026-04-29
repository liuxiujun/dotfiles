-- Tree-sitter 核心及其扩展。
--      如 treesitter.lua, treesitter-context.lua, treesitter-textobjects.lua。
-- todo:
--  nvim-ts-rainow 彩虹括号，为不同层级的括号 () {} [] 赋予不同颜色，让代码一目了然
--  nvim-treesitter-endwise 自动添加end， 在Ruby，Lua，Vimscript等语言中自动补齐end
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
			---@diagnostic disable-next-line: param-type-mismatch
			require("nvim-treesitter").setup({
				auto_install = true,
				ensure_installed = {
					-- "stable",
					-- "unstable",
					"lua",
				},
			})
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
	-- 2. treesitter-textobjects
	{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
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
		config = true,
	},
	-- 5. nvim-treesitter-endwise
	{
		"RRethy/nvim-treesitter-endwise",
	},
}
