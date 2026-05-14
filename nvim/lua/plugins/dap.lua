return {
	-- 1. nvim-dap：调试核心，配置 Java 适配器
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		config = function()
			local dap = require("dap")
			local mason_data = vim.fn.stdpath("data") .. "\\mason\\packages"

			-- Java 调试适配器
			dap.adapters.java = function(callback)
				local jda_path = mason_data .. "\\java-debug-adapter\\extension\\server"
				local jar_pattern = jda_path .. "\\com.microsoft.java.debug.plugin-*.jar"
				local jar = vim.fn.glob(jar_pattern)
				if jar == "" then
					vim.notify("java-debug-adapter jar not found, run :Mason", vim.log.levels.ERROR)
					return
				end
				callback({
					type = "executable",
					command = "java",
					args = { "-jar", jar },
				})
			end

			-- Java 测试用配置（占位）
			dap.configurations.java = {
				{
					type = "java",
					request = "launch",
					name = "Launch Java Test (Current File)",
				},
			}
		end,
	},

	-- 2. nvim-dap-ui：图形化调试界面（原配置保留）
	{
		"rcarriga/nvim-dap-ui",
		lazy = true,
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio", -- 你的原依赖保留
		},
		config = function()
			require("dapui").setup()
		end,
	},

	-- 3. nvim-dap-virtual-text：调试时变量值显示（原配置保留）
	{
		"theHamsta/nvim-dap-virtual-text",
		lazy = true,
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-treesitter/nvim-treesitter", -- 原依赖保留
		},
		config = function()
			require("nvim-dap-virtual-text").setup() -- 注意可能需要 .setup()
		end,
	},
}
