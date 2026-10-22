--------------------------------------------------------------------------------
-- 插件名称：nvim-dap 调试套件
-- 包含组件：
--   1. mfussenegger/nvim-dap           DAP 核心引擎（断点控制、单步执行、会话调度）
--   2. jay-babu/mason-nvim-dap.nvim    外部调试适配器集成
--   3. rcarriga/nvim-dap-ui            调试交互 UI 面板（变量树、堆栈、监视、终端）
--   4. theHamsta/nvim-dap-virtual-text 代码行内实时显示变量值提示
--   5. mfussenegger/nvim-dap-python    Python 专用调试扩展
-- 常用按键：<F5> (启动/继续)、<F10/11/12> (步过/步入/步出)、<leader>db (断点)、<leader>du (调试面板)
--------------------------------------------------------------------------------

-- ============================================================================
-- 1. 辅助函数：跨平台路径与 Mason 适配器定位
-- ============================================================================
local function join_paths(...)
	local separator = package.config:sub(1, 1)
	return table.concat({ ... }, separator)
end

local function mason_package_path(package_name)
	local ok, registry = pcall(require, "mason-registry")
	if not ok or not registry.has_package(package_name) then
		return nil
	end

	local package = registry.get_package(package_name)
	if not package:is_installed() then
		return nil
	end

	return package:get_install_path()
end

local function debugpy_python()
	local debugpy = mason_package_path("debugpy")
	if not debugpy then
		return vim.fn.exepath("python3") ~= "" and "python3" or "python"
	end

	if vim.fn.has("win32") == 1 then
		return join_paths(debugpy, "venv", "Scripts", "python.exe")
	end

	return join_paths(debugpy, "venv", "bin", "python")
end

local function js_debug_adapter_path()
	local pkg = mason_package_path("js-debug-adapter")
	if not pkg then
		return nil
	end
	return join_paths(pkg, "js-debug", "src", "dapDebugServer.js")
end

return {
	-- ========================================================================
	-- 2. 外部调试器安装集成 (mason-nvim-dap)
	-- ========================================================================
	{
		"jay-babu/mason-nvim-dap.nvim",
		lazy = true,
		cmd = { "DapInstall", "DapUninstall" },
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			automatic_installation = true,
			handlers = {
				function(config)
					require("mason-nvim-dap").default_setup(config)
				end,
				python = function() end, -- 禁用 mason-nvim-dap 对 python 的默认配置，由 nvim-dap-python 独占管理
			},
		},
	},

	-- ========================================================================
	-- 3. DAP 核心引擎 (nvim-dap)
	-- ========================================================================
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		dependencies = {
			"mason-org/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
		},
		keys = {
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "Debug: start/continue",
			},
			{
				"<F9>",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Debug: toggle breakpoint",
			},
			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				desc = "Debug: step over",
			},
			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				desc = "Debug: step into",
			},
			{
				"<F12>",
				function()
					require("dap").step_out()
				end,
				desc = "Debug: step out",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Debug: toggle breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Debug: conditional breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Debug: run to cursor",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.open()
				end,
				desc = "Debug: open REPL",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Debug: run last",
			},
			{
				"<leader>dx",
				function()
					require("dap").terminate()
				end,
				desc = "Debug: terminate",
			},
		},
		config = function()
			local dap = require("dap")

			-- 3.1 窗口跳转策略：优先在已打开代码窗口中定位，避免误跳入 dap-ui 侧边栏
			dap.defaults.fallback.switchbuf = "useopen,uselast"

			-- 3.2 自定义断点与调试指示图标（Nerd Font 图标与语义化着色）
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
			local dap_icons = {
				Stopped = { "➜ ", "DiagnosticWarn", "DapStoppedLine" },
				Breakpoint = { "● ", "DiagnosticError" },
				BreakpointCondition = { "○ ", "DiagnosticWarn" },
				BreakpointRejected = { " ", "DiagnosticWarn" }, -- 断点被调试器拒绝/未挂载成功（VS Code 中的空心/不可用断点）
				LogPoint = { "◆ ", "DiagnosticInfo" },
			}
			for name, sign in pairs(dap_icons) do
				vim.fn.sign_define("Dap" .. name, {
					text = sign[1],
					texthl = sign[2],
					linehl = sign[3] or "",
					numhl = sign[2],
				})
			end

			-- 3.3 JavaScript / TypeScript (Node.js) 适配器与运行配置
			local js_adapter = js_debug_adapter_path()
			if js_adapter then
				dap.adapters["pwa-node"] = function(cb, config)
					cb({
						type = "server",
						host = "127.0.0.1",
						port = "${port}",
						executable = {
							command = "node",
							args = { js_adapter, "${port}", "127.0.0.1" },
							detached = false,
						},
					})
				end
				dap.adapters["node"] = function(cb, config)
					dap.adapters["pwa-node"](cb, config)
				end

				local js_configs = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch Current File (Node.js)",
						program = "${file}",
						cwd = "${workspaceFolder}",
						sourceMaps = true,
						protocol = "inspector",
						console = "internalConsole",
						outputCapture = "std",
						skipFiles = {
							"<node_internals>/**",
							"node_modules/**",
						},
						resolveSourceMapLocations = {
							"${workspaceFolder}/**",
							"!**/node_modules/**",
						},
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach to Process (pick process)",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
						sourceMaps = true,
						skipFiles = {
							"<node_internals>/**",
							"node_modules/**",
						},
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach to Port (9229)",
						port = 9229,
						cwd = "${workspaceFolder}",
						sourceMaps = true,
						restart = true,
						skipFiles = {
							"<node_internals>/**",
							"node_modules/**",
						},
						resolveSourceMapLocations = {
							"${workspaceFolder}/**",
							"!**/node_modules/**",
						},
					},
				}

				for _, language in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
					dap.configurations[language] = js_configs
				end
			end
		end,
	},

	-- ========================================================================
	-- 4. Python 专用适配与测试扩展 (nvim-dap-python 官方最佳实践)
	-- ========================================================================
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = { "mfussenegger/nvim-dap", "mason-org/mason.nvim" },
		keys = {
			{
				"<leader>dpm",
				function()
					require("dap-python").test_method()
				end,
				desc = "Debug: Python test method",
				ft = "python",
			},
			{
				"<leader>dpc",
				function()
					require("dap-python").test_class()
				end,
				desc = "Debug: Python test class",
				ft = "python",
			},
		},
		config = function()
			local dappy = require("dap-python")
			dappy.setup(debugpy_python(), {
				console = "internalConsole",
			})

			-- 精炼定制 Python configurations（与全局 REPL 控制台及常用调试场景对齐）
			local dap = require("dap")
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch Current File (Python)",
					program = "${file}",
					cwd = "${workspaceFolder}",
					console = "internalConsole",
					justMyCode = true,
				},
				{
					type = "python",
					request = "launch",
					name = "Launch Current File with Arguments (Python)",
					program = "${file}",
					args = function()
						local args_string = vim.fn.input("Arguments: ")
						return vim.split(args_string, " +", { trimempty = true })
					end,
					cwd = "${workspaceFolder}",
					console = "internalConsole",
					justMyCode = true,
				},
				{
					type = "python",
					request = "attach",
					name = "Attach to Process (pick process)",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
				{
					type = "python",
					request = "attach",
					name = "Attach to Remote Port (5678)",
					connect = { host = "127.0.0.1", port = 5678 },
					cwd = "${workspaceFolder}",
				},
			}
		end,
	},

	-- ========================================================================
	-- 5. 调试交互 UI 面板与自动开关钩子 (dap-ui)
	-- ========================================================================
	{
		"rcarriga/nvim-dap-ui",
		lazy = true,
		dependencies = {
			"nvim-neotest/nvim-nio",
		},
		keys = {
			{
				"<leader>dt",
				function()
					local ok_overseer, overseer = pcall(require, "overseer")
					if ok_overseer then
						overseer.close()
					end
					require("dapui").toggle()
				end,
				desc = "Debug: toggle UI",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval(nil, { enter = true })
				end,
				desc = "Debug: eval expression",
				mode = { "n", "v" },
			},
			{
				"<F8>",
				function()
					require("dapui").eval(nil, { enter = true })
				end,
				desc = "Debug: eval expression (jump in)",
				mode = { "n", "v" },
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup({
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							{ id = "repl", size = 1.0 },
						},
						size = 10,
						position = "bottom",
					},
				},
			})

			local function close_colliding_sidebars()
				local ok_tree, tree_api = pcall(require, "nvim-tree.api")
				if ok_tree and tree_api.tree.is_visible() then
					tree_api.tree.close()
				end
				local ok_overseer, overseer = pcall(require, "overseer")
				if ok_overseer then
					overseer.close()
				end
			end

			-- 调试会话建立时：自动收起 nvim-tree 与 overseer 窗口（互斥），展开 dap-ui
			dap.listeners.after.event_initialized["dapui_config"] = function()
				close_colliding_sidebars()
				dapui.open()
			end
			-- 调试结束/退出时：自动关闭 dap-ui，恢复干净的编辑区
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},

	-- ========================================================================
	-- 6. 代码行内变量值实时提示 (dap-virtual-text)
	-- ========================================================================
	{
		"theHamsta/nvim-dap-virtual-text",
		lazy = true,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {},
	},
}
