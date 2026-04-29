-- Tree-sitter 核心及其扩展。
--      如 treesitter.lua, treesitter-context.lua, treesitter-textobjects.lua。
-- todo:
--  nvim-ts-rainow 彩虹括号，为不同层级的括号 () {} [] 赋予不同颜色，让代码一目了然
--  nvim-treesitter-endwise 自动添加end， 在Ruby，Lua，Vimscript等语言中自动补齐end
--  nvim-treesitter-refactor 智能代码重构
--  nvim-ts-context-commentstring 智能注释， 根据光标所在位置（代码中还是字符串里），自动设置正确的注释符号

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	opts = {
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = {
			enable = true,
			disable = { "markdown" },
		},
		auto_install = true,
		ensure_installed = {
			"lua",
			"luadoc",
			"vim",
			"vimdoc",
			"yaml",
			"xml",
			"json",
			"python",
			"c",
			"cpp",
			"make",
			"go",
			"java",
			"html",
			"css",
			"javascript",
			"typescript",
			"markdown",
			"markdown_inline",
			"diff",
			"gitignore",
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gss",
				node_incremental = "gsi",
				scope_incremental = "gsc",
				node_decremental = "gsd",
			},
		},
	},
	config = function(_, opts)
		-- 核心：不再 require("nvim-treesitter.configs")
		-- 如果使用的是 main 分支，通常直接調用內置的 setup (如果有的話)
		-- 或者讓 Lazy 處理。若要手動設置語言註冊：
		vim.treesitter.language.register("markdown", "blink-cmp-documentation")

		-- 使用 Neovim 內置的 TS 折疊 (0.11+ 推薦)
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt.foldenable = false
	end,
}
