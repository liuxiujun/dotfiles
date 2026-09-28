--------------------------------------------------------------------------------
-- 插件名称：akinsho/bufferline.nvim
-- 功能用途：顶部缓冲区标签栏（将已打开的 Buffer 渲染为类似 IDE 的顶部标签页，显示诊断图标）
-- 常用按键：[b / ]b (切换标签)、<leader>bp (字母快速跳选标签)、<leader>bo (关闭其他标签)
--------------------------------------------------------------------------------
return {
	"akinsho/bufferline.nvim",
	version = "*", -- 跟踪最新稳定版
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- 文件图标
	},
	event = "VeryLazy",
	keys = {
		{ "<leader>bp", "<cmd>BufferLinePick<CR>", desc = "Pick buffer" },
		{ "<leader>bP", "<cmd>BufferLinePickClose<CR>", desc = "Pick buffer to close" },
		{ "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", desc = "Close other buffers" },
	},
	opts = function()
		local highlights = nil
		if package.loaded["ofirkai"] then
			local ok_hl, ofirkai_buf = pcall(require, "ofirkai.tablines.bufferline")
			if ok_hl then
				highlights = ofirkai_buf.highlights
			end
		end

		return {
			highlights = highlights,
			options = {
				mode = "buffers",
				themable = true,
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
		}
	end,
}
