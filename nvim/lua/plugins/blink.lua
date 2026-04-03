-- blink.cmp 自动补全
local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

return {
	"Saghen/blink.cmp",
	dependencies = {
		"xzbdmw/colorful-menu.nvim",
		"rafamadriz/friendly-snippets",
	},
	version = "1.*",
	event = { "InsertEnter", "CmdlineEnter" },
	opts = {
		keymap = {
			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-U>"] = { "scroll_documentation_up", "fallback" },
			["<C-D>"] = { "scroll_documentation_down", "fallback" },
			["<C-e>"] = { "hide", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = {
				"snippet_forward",
				"select_next",
				function(cmp)
					if has_words_before() or vim.api.nvim_get_mode().mode == "c" then
						return cmp.show()
					end
				end,
				"fallback",
			},
			["<S-Tab>"] = {
				"select_prev",
				"snippet_backward",
				function(cmp)
					if vim.api.nvim_get_mode().mode == "c" then
						return cmp.show()
					end
				end,
				"fallback",
			},
		},
		completion = {
			list = { selection = { preselect = false } },
			documentation = { auto_show = true },
			menu = {
				border = "rounded",
				draw = {
					columns = { { "kind_icon" }, { "label", gap = 1 } },
					components = {
						label = {
							text = function(ctx)
								return require("colorful-menu").blink_components_text(ctx)
							end,
							highlight = function(ctx)
								return require("colorful-menu").blink_components_highlight(ctx)
							end,
						},
					},
				},
			},
		},
		signature = {
			enabled = true,
		},
		cmdline = {
			completion = {
				list = { selection = { preselect = false } },
				menu = {
					auto_show = true,
				},
			},
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
	},
	opts_extends = { "source.default" },
}
