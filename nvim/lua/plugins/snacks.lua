--------------------------------------------------------------------------------
-- 插件名称：folke/snacks.nvim (+ echasnovski/mini.icons)
-- 功能用途：现代化瑞士军刀插件集（接管模糊搜索 Picker、文件树 Explorer、缩进线 Indent、状态列 Statuscolumn、终端 Terminal、同名符号高亮 Words、无损关 Buffer Bufdelete、Git 单行追溯、动态开关 Toggle、通知 Notifier、输入框 Input 及大文件防卡死 Bigfile）
-- 常用按键：<leader>ff (找文件)、<leader>fg (全局搜索)、<leader>e (开关文件树)、<C-\> (开关终端)、<leader>gb (Git 单行历史)、<leader>u* (UI 动态开关)
--------------------------------------------------------------------------------
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	dependencies = {
		"echasnovski/mini.icons",
	},
	---@type snacks.Config
	opts = {
		-- 1. 性能防护：打开超大文件（如日志/压缩包）自动禁用 Treesitter 与慢插件防卡死
		bigfile = { enabled = true },
		-- 2. 极速渲染：在插件加载完成前瞬间把文件内容渲染上屏
		quickfile = { enabled = true },
		-- 3. 缩进对齐线（替代 indent-blankline.nvim，内置平滑高亮当前代码块作用域）
		indent = { enabled = true },
		-- 4. 美化输入框（接管 vim.ui.input，让 grn 重命名等弹窗变成精致浮动输入框）
		input = { enabled = true },
		-- 5. 右上角浮动通知气泡（接管 vim.notify）
		notifier = { enabled = true },
		-- 6. 终端管理（替代 toggleterm.nvim，支持浮动/分屏与多实例切换）
		terminal = { enabled = true },
		-- 7. 同名符号自动高亮与跳转（替代 autocmds.lua 手动 LspDocumentHighlight）
		words = { enabled = true },
		-- 8. 左侧行号与状态列美化（规整诊断图标、行号与代码折叠列，支持鼠标点击折叠）
		statuscolumn = { enabled = true },
		-- 9. 侧边栏文件树（替代 nvim-tree.lua，复用 picker 架构，支持实时模糊过滤）
		explorer = {
			enabled = true,
			replace_netrw = true,
		},
		-- 10. 统一模糊搜索器（替代 telescope.nvim + 接管 vim.ui.select）
		picker = {
			enabled = true,
			ui_select = true, -- 自动接管 gra (Code Action) 与 Overseer 选择弹窗
			sources = {
				files = {
					hidden = true, -- 对应原 telescope 的 hidden = true
				},
				explorer = {
					hidden = true,
					ignored = true, -- 对应原 nvim-tree 的 git.ignore = false（显示 gitignore 文件）
				},
			},
			win = {
				input = {
					keys = {
						-- 保留你习惯的按一次 <Esc> 直接关闭搜索窗（无需退回 Normal 模式再按 q）
						["<Esc>"] = { "close", mode = { "n", "i" } },
						-- 保留你习惯的 <C-u> / <C-d> 滚动右侧代码预览窗
						["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
						["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
					},
				},
			},
		},
	},
	keys = {
		-- 文件树开关（原 nvim-tree 快捷键完全一致）
		{
			"<leader>e",
			function()
				Snacks.explorer()
			end,
			desc = "Toggle file explorer",
		},
		-- 搜索类（原 telescope 快捷键完全一致）
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Find files",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Live grep",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Find buffers",
		},
		{
			"<leader>fh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help tags",
		},
		{
			"<leader>fo",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent files",
		},
		{
			"<leader>fw",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "Find word under cursor",
			mode = { "n", "x" },
		},
		-- 终端类（原 toggleterm 快捷键完全一致，支持 count 多终端如 2<C-\>）
		{
			[[<C-\>]],
			function()
				Snacks.terminal.toggle(nil, { count = vim.v.count1 })
			end,
			desc = "Toggle terminal",
			mode = { "n", "t" },
		},
		{
			"<leader>tf",
			function()
				Snacks.terminal.toggle(nil, { win = { position = "float", border = "rounded" } })
			end,
			desc = "Toggle floating terminal",
		},
		{
			"<leader>th",
			function()
				Snacks.terminal.toggle(nil, { win = { position = "bottom", height = 0.3 } })
			end,
			desc = "Toggle horizontal terminal",
		},
		{
			"<leader>tv",
			function()
				Snacks.terminal.toggle(nil, { win = { position = "right", width = 0.4 } })
			end,
			desc = "Toggle vertical terminal",
		},
		-- Git 辅助：弹出当前光标所在行最近 5 次 Git Commit 与 Diff 历史
		{
			"<leader>gb",
			function()
				Snacks.git.blame_line()
			end,
			desc = "Git blame line (Snacks)",
		},
		-- 同名符号引用上下跳转（配合 snacks.words）
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1, true)
			end,
			desc = "Next Reference (Snacks)",
			mode = { "n", "t" },
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1, true)
			end,
			desc = "Prev Reference (Snacks)",
			mode = { "n", "t" },
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- 与 which-key 深度集成的动态状态开关（自带绿/黄状态图标）
				Snacks.toggle.option("wrap", { name = "Wrap (自动折行)" }):map("<leader>uw")
				Snacks.toggle.option("relativenumber", { name = "Relative Number (相对行号)" }):map("<leader>ur")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.inlay_hints():map("<leader>uh")
				Snacks.toggle.indent():map("<leader>ui")
			end,
		})
	end,
}
