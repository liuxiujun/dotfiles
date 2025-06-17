return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
					disable = { "c", "rust" },
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
					disable = { "markdown" },
				},
				sync_install = false,
				auto_install = true,
				ignore_install = { "javascript" },
				ensure_installed = {
					"c",
					"lua",
					"vim",
					"yaml",
					"xml",
					"dtd",
					"scheme",
					"sql",
					"python",
					"groovy",
					"make",
					"json",
					"java",
					"html",
					"css",
					"javascript",
					"typescript",
					"tsx",
					"vue",
					"llvm",
					"dockerfile",
					"git_rebase",
					"gitcommit",
					"gitattributes",
					"gitignore",
					"diff", -- git diff
					"markdown_inline",
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
			})

			-- Hints:
			--   A uppercase letter followed `z` means recursive
			--   zo: open one fold under the cursor
			--   zc: close one fold under the cursor
			--   za: toggle the folding
			--   zv: open just enough folds to make the line in which the cursor is located not folded
			--   zM: close all foldings
			--   zR: open all foldings
			-- source: https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation
			vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" }, {
				group = vim.api.nvim_create_augroup("TS_FOLD_WORKAROUND", {}),
				callback = function()
					vim.opt.foldmethod = "expr"
					vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
					vim.opt.foldenable = false
				end,
			})

			vim.cmd("set foldmethod=expr")
			vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
			vim.cmd("set nofoldenable")

			-- RMarkdown doesn't have a good treesitter parser, but Markdown does
			vim.treesitter.language.register("markdown", "rmd")
			vim.treesitter.language.register("markdown", "rmarkdown")
		end,
	},
}
