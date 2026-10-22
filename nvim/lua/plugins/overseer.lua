--------------------------------------------------------------------------------
-- 插件名称：stevearc/overseer.nvim
-- 功能用途：异步任务运行与构建管理器（类似 VSCode Tasks，支持运行脚本、编译构建与查看任务输出面板）
-- 常用按键：<leader>rr (选择任务)、<leader>rl (重跑上次任务)、<leader>rx (停止任务)、<leader>rt (开关任务面板)、<leader>rc (清理已完成)
--------------------------------------------------------------------------------
return {
	"stevearc/overseer.nvim",
	cmd = {
		"OverseerRun",
		"OverseerToggle",
		"OverseerShell",
		"OverseerTaskAction",
	},
	keys = {
		-- 任务运行与管理
		{ "<leader>rr", "<cmd>OverseerRun<cr>", desc = "Run task from template" },
		{
			"<leader>rl",
			function()
				local overseer = require("overseer")
				local tasks = overseer.list_tasks({ recent_first = true })
				if vim.tbl_isempty(tasks) then
					vim.notify("No recent task to re-run", vim.log.levels.WARN)
				else
					overseer.run_action(tasks[1], "restart")
				end
			end,
			desc = "Re-run last task",
		},
		{
			"<leader>rx",
			function()
				local overseer = require("overseer")
				local running = overseer.list_tasks({ status = "RUNNING" })
				if #running == 0 then
					vim.notify("No running tasks to stop", vim.log.levels.WARN)
				elseif #running == 1 then
					running[1]:stop()
					vim.notify("Stopped task: " .. running[1].name, vim.log.levels.INFO)
				else
					overseer.task_action()
				end
			end,
			desc = "Stop running task",
		},
		{
			"<leader>rX",
			function()
				local overseer = require("overseer")
				local running = overseer.list_tasks({ status = "RUNNING" })
				if #running == 0 then
					vim.notify("No running tasks to stop", vim.log.levels.WARN)
				else
					for _, task in ipairs(running) do
						task:stop()
					end
					vim.notify(string.format("Stopped %d running task(s)", #running), vim.log.levels.INFO)
				end
			end,
			desc = "Stop ALL running tasks",
		},
		{
			"<leader>rt",
			function()
				local ok_dapui, dapui = pcall(require, "dapui")
				if ok_dapui then
					dapui.close()
				end
				require("overseer").toggle()
			end,
			desc = "Toggle task list panel (close dap-ui)",
		},
		{
			"<leader>ro",
			function()
				local overseer = require("overseer")
				local tasks = overseer.list_tasks({ recent_first = true })
				if vim.tbl_isempty(tasks) then
					vim.notify("No tasks found", vim.log.levels.WARN)
				else
					tasks[1]:open_output("float")
				end
			end,
			desc = "Open last task output (Float)",
		},
		{ "<leader>rb", "<cmd>OverseerRun BUILD<cr>", desc = "Run build task" },
		{ "<leader>ra", "<cmd>OverseerShell<cr>", desc = "Run shell command as task" },
		{ "<leader>rq", "<cmd>OverseerTaskAction<cr>", desc = "Select a task action" },
		{
			"<leader>rc",
			function()
				local overseer = require("overseer")
				local count = 0
				for _, task in ipairs(overseer.list_tasks()) do
					if task:is_complete() then
						task:dispose()
						count = count + 1
					end
				end
				vim.notify(string.format("Cleared %d completed task(s)", count), vim.log.levels.INFO)
			end,
			desc = "Clear completed tasks",
		},
	},
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"akinsho/toggleterm.nvim",
	},
	opts = {
		-- Patch nvim-dap to support preLaunchTask and postDebugTask
		dap = true,
		-- Configure the task output buffer and window
		output = {
			-- Use a terminal buffer to display output. If false, a normal buffer is used
			use_terminal = true,
			-- If true, don't clear the buffer when a task restarts
			preserve_output = false,
		},
		task_list = {
			-- Default direction. Can be "left", "right", or "bottom"
			direction = "bottom",
			-- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
			-- min_width and max_width can be a single value or a list of mixed integer/float types.
			-- max_width = {100, 0.2} means "the lesser of 100 columns or 20% of total"
			max_width = { 100, 0.2 },
			-- min_width = {40, 0.1} means "the greater of 40 columns or 10% of total"
			min_width = { 40, 0.1 },
			max_height = { 20, 0.2 },
			min_height = 8,
			-- String that separates tasks
			separator = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
			-- Indentation for child tasks
			child_indent = { "┃ ", "┣━", "┗━" },
			-- Function that renders tasks. See lua/overseer/render.lua for built-in options
			-- and for useful functions if you want to build your own.
			render = function(task)
				return require("overseer.render").format_standard(task)
			end,
			-- The sort function for tasks
			sort = function(a, b)
				return require("overseer.task_list").default_sort(a, b)
			end,
			-- 任务面板内部的极速操作按键
			keymaps = {
				["?"] = "keymap.show_help",
				["g?"] = "keymap.show_help",
				["<CR>"] = "keymap.run_action",
				["x"] = { "keymap.run_action", opts = { action = "stop" }, desc = "Stop task" },
				["s"] = { "keymap.run_action", opts = { action = "stop" }, desc = "Stop task" },
				["<C-c>"] = { "keymap.run_action", opts = { action = "stop" }, desc = "Stop task" },
				["r"] = { "keymap.run_action", opts = { action = "restart" }, desc = "Restart task" },
				["w"] = { "keymap.run_action", opts = { action = "watch" }, desc = "Watch on save" },
				["dd"] = { "keymap.run_action", opts = { action = "dispose" }, desc = "Dispose task" },
				["o"] = "keymap.open",
				["<C-f>"] = { "keymap.open", opts = { dir = "float" }, desc = "Open task output in float" },
				["<C-v>"] = { "keymap.open", opts = { dir = "vsplit" }, desc = "Open task output in vsplit" },
				["<C-s>"] = { "keymap.open", opts = { dir = "split" }, desc = "Open task output in split" },
				["p"] = "keymap.toggle_preview",
				["{"] = "keymap.prev_task",
				["}"] = "keymap.next_task",
				["<C-k>"] = "keymap.scroll_output_up",
				["<C-j>"] = "keymap.scroll_output_down",
				["q"] = { "<cmd>close<cr>", desc = "Close task list" },
			},
		},
		-- Custom actions for tasks. See :help overseer-actions
		actions = {},
		-- Configure the floating window used for task templates that require input
		-- and the floating window used for editing tasks
		form = {
			zindex = 40,
			-- Dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
			-- min_X and max_X can be a single value or a list of mixed integer/float types.
			min_width = 80,
			max_width = 0.9,
			min_height = 10,
			max_height = 0.9,
			border = nil,
			-- Set any window options here (e.g. winhighlight)
			win_opts = {},
		},
		-- Configuration for task floating output windows
		task_win = {
			-- How much space to leave around the floating window
			padding = 2,
			border = nil,
			-- Set any window options here (e.g. winhighlight)
			win_opts = {},
		},
		-- Aliases for bundles of components. Redefine the builtins, or create your own.
		component_aliases = {
			-- Most tasks are initialized with the default components
			default = {
				"on_exit_set_status",
				"on_complete_notify",
				{ "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
                -- 只要任务启动，如果底部窗口未开就自动停靠展开，且 focus = false 绝不抢走代码光标
                { "open_output", direction = "dock", on_start = "always", focus = false },
			},
			-- Tasks from tasks.json use these components
			default_vscode = {
				"default",
				"on_result_diagnostics",
			},
			-- Tasks created from experimental_wrap_builtins
			default_builtin = {
				"on_exit_set_status",
				"on_complete_dispose",
				{ "unique", soft = true },
			},
			-- List of other directories to search for task templates.
			-- This will search under the runtimepath, so for example
			-- "foo/bar" will search "<runtimepath>/lua/foo/bar/*"
			template_dirs = {},
			-- List of module names or lua patterns that match modules (must start with '^')
			-- to disable. This can be used to disable built in task providers.
			disable_template_modules = {
				-- "overseer.template.make",
				-- "^.*cargo",
			},
			-- For template providers, how long to wait before timing out.
			-- Set to 0 to wait forever.
			template_timeout_ms = 3000,
			-- Cache template provider results if the provider takes longer than this to run.
			-- Set to 0 to disable caching.
			template_cache_threshold_ms = 200,
			log_level = vim.log.levels.WARN,
			-- Overseer can wrap any call to vim.system and vim.fn.jobstart as a task.
			experimental_wrap_builtins = {
				enabled = false,
				condition = function(cmd, caller, opts)
					return true
				end,
			},
		},
	},
}
