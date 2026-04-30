-- ui.lua：界面美化相关，包括主题（如 colorscheme.lua）、状态栏（lualine.lua）、文件树（nvim-tree.lua）、标签栏（bufferline 等）、缩进线（indent-blankline.lua）等。
--
-- lsp.lua：所有 LSP 相关，包括 Mason、lspconfig、cmp（补全）、Lsp-progress、trouble、vue 等。可以把 LSP 客户端、补全、诊断 UI 整合在一起。
--
-- treesitter.lua：Tree-sitter 核心及其扩展，如 treesitter.lua, treesitter-context.lua, treesitter-textobjects.lua。
--
-- editor.lua：编辑增强插件，如 comment.lua, surround.lua, hop.lua, accelerate-jk.lua, toggleterm.lua, which-key.lua 等。
--
-- tools.lua：工具类插件，如 telescope.lua, ufo.lua, dap.lua, conform.lua（格式化），osc52.lua 等。
--
-- config/ 目录：可以保持原样，也可以将 autocmd.lua、keymaps.lua、options.lua 合并为一个 settings.lua 或 core.lua，但保持分离也完全可以。
--

return {
	-- bufferline.nvim - 顶部标签栏
	"akinsho/bufferline.nvim",
	version = "*", -- 跟踪最新稳定版
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- 文件图标
		"echasnovski/mini.nvim",
	},
	event = "VeryLazy", -- 确保插件在启动时加载
	opts = {
		options = {
			mode = "buffers",
			-- 关闭按钮、图标、名称等显示方式
			close_command = "bdelete! %d", -- 关闭 buffer 的命令
			left_mouse_command = "buffer %d", -- 左键切换到 buffer
			middle_mouse_command = nil, -- 中键无操作

			-- 显示风格
			separator_style = "slant", -- "slant" | "slope" | "thick" | "thin"

			-- 图标配置（需要 nvim-web-devicons）
			diagnostics = "nvim_lsp", -- 显示 LSP 诊断状态（错误/警告）
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				local s = " "
				for e, n in pairs(diagnostics_dict) do
					local sym = e == "error" and " " or (e == "warning" and " " or " ")
					s = s .. n .. sym
				end
				return s
			end,
            hover = {
                enabled = true,
                delay = 200,
                reveal = {'close'}
            },
			-- 偏移量：为 LSP 或文件树保留左侧空间
			offsets = {
				{
					filetype = "NvimTree",
					-- text = "File Explorer",
					text_align = "center",
					separator = true,
				},
				{
					filetype = "TelescopePrompt",
					-- text = "Telescope",
					text_align = "center",
					separator = true,
				},
			},
		},
	},
}
