return {
	"mfussenegger/nvim-dap",
	config = function()
		local dap = require("dap")
		local mason_data = vim.fn.stdpath("data") .. "\\mason\\packages" -- Windows 反斜杠

		-- java-debug 适配器
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
				command = "java", -- 确保 java 在 PATH 中
				args = { "-jar", jar },
			})
		end

		-- java-test 配置（占位）
		dap.configurations.java = {
			{
				type = "java",
				request = "launch",
				name = "Launch Java Test (Current File)",
			},
		}
	end,
}
