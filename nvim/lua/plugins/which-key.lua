--------------------------------------------------------------------------------
-- 插件名称：folke/which-key.nvim
-- 功能用途：快捷键实时提示弹窗（按下前缀键如 <leader> 或 g 后，自动弹出后续可用按键菜单）
-- 常用按键：<leader>? (查看当前 Buffer 绑定的局部快捷键)
--------------------------------------------------------------------------------
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
        spec = {
            { "<leader>l", group = "LSP" },
            { "<leader>f", group = "Find" },
            { "<leader>b", group = "Buffer" },
            { "<leader>r", group = "Run (Overseer)" },
            { "<leader>c", group = "Code / Diagnostics" },
            { "<leader>d", group = "Debug (DAP)" },
            { "<leader>t", group = "Trouble / Terminal" },
            { "<leader>g", group = "Git" },
            { "<leader>u", group = "UI / Toggle" },
            { "<leader><leader>", group = "Flash Jump" },
        },
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
