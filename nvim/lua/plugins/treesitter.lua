-- Tree-sitter 核心及其扩展。
--      如 treesitter.lua, treesitter-context.lua, treesitter-textobjects.lua。

return {
    -- 1. treesitter
	{
		"nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false,
		-- version = false,
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
					"lua", "luadoc",
					"vim", "vimdoc",
					"yaml", "xml", "dtd", "json", "json5", "http",
					"sql",
					"python",
                    "perl",
					"c", "cpp", "make", "llvm",
					"java", "groovy",
					"html", "css", "javascript", "typescript",
					"dockerfile",
					"git_rebase", "gitcommit", "gitattributes", "gitignore", "git_config", "diff", -- git diff
					"markdown", "markdown_inline",
                    -- "gdscript", "gdshader",
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

    -- 2. treesitter-content
    --      将窗口顶部固定显示当前代码块的上下文，如所在函数名
    {
        "nvim-treesitter/nvim-treesitter-context",
        enabled = false,
        opts = {
            max_lines = 3,
        },
    },

    -- 3. treesitter-textobjects
    --      将语法树节点变成可操作的对象，如函数、参数  
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = "nvim-treesitter/nvim-treesitter",
        enabled = true,
        config = function()
            local is_ok, configs = pcall(require, "nvim-treesitter.configs")
            if not is_ok then
                return
            end

            configs.setup({
                textobjects = {
                    select = {
                        enable = true,

                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,

                        keymaps = {
                            -- outer: outer part
                            -- inner: inner part
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["al"] = "@loop.outer",
                            ["il"] = "@loop.inner",
                        },
                        -- If you set this to `true` (default is `false`) then any textobject is
                        -- extended to include preceding or succeeding whitespace. Succeeding
                        -- whitespace has priority in order to act similarly to eg the built-in
                        -- `ap`.
                        --
                        -- Can also be a function which gets passed a table with the keys
                        -- * query_string: eg '@function.inner'
                        -- * selection_mode: eg 'v'
                        -- and should return true or false
                        include_surrounding_whitespace = true,
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]]"] = { query = "@class.outer", desc = "Next class start" },
                        --
                        -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
                        ["]o"] = "@loop.*", -- that is, ["]o"] = { query = { "@loop.inner", "@loop.outer" } }

                        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                    },
                    goto_next_end = {
                        ["]M"] = "@function.outer",
                        ["]["] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[["] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[M"] = "@function.outer",
                        ["[]"] = "@class.outer",
                    },
                    -- Below will go to either the start or the end, whichever is closer.
                    -- Use if you want more granular movements
                    -- Make it even more gradual by adding multiple queries and regex.
                    goto_next = {
                        ["]d"] = "@conditional.outer",
                    },
                    goto_previous = {
                        ["[d"] = "@conditional.outer",
                    },
                },
            })
        end,
    },
    -- todo: 
    --  nvim-ts-rainow 彩虹括号，为不同层级的括号 () {} [] 赋予不同颜色，让代码一目了然
    --  nvim-treesitter-endwise 自动添加end， 在Ruby，Lua，Vimscript等语言中自动补齐end
    --  nvim-treesitter-refactor 智能代码重构
    --  nvim-ts-context-commentstring 智能注释， 根据光标所在位置（代码中还是字符串里），自动设置正确的注释符号
}
