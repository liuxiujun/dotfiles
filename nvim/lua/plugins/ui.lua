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
	},
    event = "VeryLazy",     -- 确保插件在启动时加载
	keys = {
		-- 标签页切换
		{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
		{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
		-- 移动标签位置
		{ "<leader>bp", "<Cmd>BufferLineMovePrev<CR>", desc = "Move buffer prev" },
		{ "<leader>bn", "<Cmd>BufferLineMoveNext<CR>", desc = "Move buffer next" },
		-- 关闭
		{ "<leader>bc", "<Cmd>BufferLinePickClose<CR>", desc = "Pick buffer to close" },
		{ "<leader>bq", "<Cmd>bd<CR>", desc = "Close current buffer" }, -- 原生关闭，也可以保留
		-- 快速跳转（按序号）
		{ "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", desc = "Goto buffer 1" },
		{ "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", desc = "Goto buffer 2" },
		{ "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", desc = "Goto buffer 3" },
		{ "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", desc = "Goto buffer 4" },
		{ "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", desc = "Goto buffer 5" },
		{ "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", desc = "Goto buffer 6" },
		{ "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", desc = "Goto buffer 7" },
		{ "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", desc = "Goto buffer 8" },
		{ "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>", desc = "Goto buffer 9" },
		-- 更多序号可自行添加
	},
	opts = {
		options = {
			-- 关闭按钮、图标、名称等显示方式
			close_command = "bdelete! %d", -- 关闭 buffer 的命令
			right_mouse_command = "bdelete! %d", -- 右键关闭
			left_mouse_command = "buffer %d", -- 左键切换到 buffer
			middle_mouse_command = nil, -- 中键无操作

			-- 显示风格
			show_buffer_close_icons = true, -- 显示单个 buffer 的关闭图标
			show_close_icon = true, -- 显示标签栏右侧的“关闭所有”图标
			show_tab_indicators = true, -- 显示当前 tab 下的 buffer 指示器
			persist_buffer_sort = true, -- 重启后保持 buffer 排序

			-- 分隔符样式（可以是 "slant", "thick", "thin" 等）
			separator_style = "slant", -- 或 "padded_slant", "slope", "thick"

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

			-- 鼠标悬停显示诊断信息
			hover = {
				enabled = true,
				delay = 200,
				reveal = { "close" },
			},

			-- 自定义 buffer 名称
			custom_filter = function(buf_number, buf_numbers)
				-- 过滤掉特殊 buffer（如 nvim-tree、help 等）
				local buf_name = vim.api.nvim_buf_get_name(buf_number)
				local filetype = vim.bo[buf_number].filetype
				return not (filetype == "NvimTree" or filetype == "help" or buf_name:match(".*Telescope.*"))
			end,

			-- 排序方式：按最近使用
			sort_by = "insert_after_current", -- 新 buffer 插入当前之后
			-- 其他选项：'id', 'extension', 'directory', 'tabs'

			-- 高亮组自定义（可配合主题）
			highlights = {
				-- 你可以在这里覆盖默认颜色，通常无需设置，主题会自动适配
				-- 例如修改选中标签的背景色
				-- buffer_selected = {
				--   gui = "bold",
				--   guifg = "#ffffff",
				--   guibg = "#3e445e",
				-- },
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
	-- 可选：在插件加载后执行额外命令（例如设置自动命令）
	config = function(_, opts)
		require("bufferline").setup(opts)
		-- 可以在此添加自动命令，例如当进入无文件状态时自动隐藏 bufferline
		vim.api.nvim_create_autocmd("BufAdd", {
			callback = function()
				-- 例如打开新 buffer 时自动切换到新 buffer（可选）
			end,
		})
	end,
}
