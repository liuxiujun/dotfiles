--------------------------------------------------------------------------------
-- 插件名称：nvim-lualine/lualine.nvim
-- 功能用途：底部状态栏（显示当前编辑模式、Git 分支/差异、诊断统计、文件路径、LSP 进度、编码与行列号）
--------------------------------------------------------------------------------
return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		{ "linrongbin16/lsp-progress.nvim", opts = {} },
		{
			"SmiteshP/nvim-navic",
			opts = {
				lsp = { auto_attach = true },
				separator = "  ",
			},
		},
	},
	config = function()
		local is_ok, lualine = pcall(require, "lualine")
		if not is_ok then
			return
		end

		local lualine_theme = "auto"
		local winbar_color = nil
		if package.loaded["ofirkai"] then
			local ok_theme, ofirkai_lualine = pcall(require, "ofirkai.statuslines.lualine")
			if ok_theme then
				lualine_theme = ofirkai_lualine.theme
				winbar_color = ofirkai_lualine.winbar_color
			end
		end

		local ok_navic, navic = pcall(require, "nvim-navic")
		local winbar_c = {}
		if ok_navic then
			table.insert(winbar_c, {
				navic.get_location,
				icon = "",
				cond = navic.is_available,
				color = winbar_color,
				separator = "",
			})
		end
		-- 保持整行 winbar 背景色统一（即使当前文件未挂载 LSP / 无符号上下文）
		table.insert(winbar_c, {
			function()
				return "%="
			end,
			color = winbar_color,
			separator = "",
		})

		local winbar = {
			lualine_a = {},
			lualine_b = {
				{
					"filename",
					icon = "",
					color = winbar_color,
					padding = { left = 4 },
					separator = "",
				},
			},
			lualine_c = winbar_c,
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		}

		lualine.setup({
			options = {
				icons_enabled = true,
				theme = lualine_theme,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = { "gitcommit", "NvimTree", "toggleterm", "fugitive", "OverseerList" },
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			-- Lualine has sections as shown below.
			-- +-------------------------------------------------+
			-- | A | B | C                             X | Y | Z |
			-- +-------------------------------------------------+
			-- Each section holds its components
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					"diff",
					"diagnostics",
				},
				lualine_c = {
					{
						"filename",
						file_status = true, -- Displays file status (read-only status, modified status)
						-- Path configurations
						-- 0: Just the filename
						-- 1: Relative path
						-- 2: Absolute path
						-- 3: Absolute path, with tilde as the home directory
						-- 4: Filename and parent dir, with tilde as the home directory
						path = 3,
						shorting_target = 40, -- Shortens path to leave 40 spaces in the window
					},
					function()
						return require("lsp-progress").progress()
					end,
				},
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = winbar,
			inactive_winbar = winbar,
			extensions = {},
		})

		-- Listen to lsp-progress event and refresh lualine
		vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
		vim.api.nvim_create_autocmd("User", {
			group = "lualine_augroup",
			pattern = "LspProgressStatusUpdated",
			callback = lualine.refresh,
		})
	end,
}
