-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

------------------------------------------------------------------------------------
--- 通过 wezterm 获取本地或远程的nvim模式，用来自动切换本地输入法
------------------------------------------------------------------------------------
local function wezterm_set_user_var(name, value)
	local encoded = vim.base64.encode(value)
	local osc = string.format("\x1b]1337;SetUserVar=%s=%s\x1b\\", name, encoded)
	if vim.env.TMUX and vim.env.TMUX ~= "" then
		-- tmux 环境：包装后通过 stdout 输出（远程服务器上工作正常）
		local wrapped = "\x1bPtmux;\x1b" .. osc:gsub("\x1b", "\x1b\x1b") .. "\x1b\\"
		io.stdout:write(wrapped)
		io.stdout:flush()
	elseif vim.fn.has("win32") == 1 then
		-- todo 这并没有生效
		-- powershell执行: Write-Host "`eP+p`e]1337;SetUserVar=IM_SWITCH=bm9ybWFs`e\`e\"
		-- 执行成功并触发日志，说明WezTerm+ConPTY 25H2之间的连接是通的，问题还是出在nvim上
		-- :lua vim.fn.chansend(vim.v.stderr, "\x1bP+p\x1b]1337;SetUserVar=IM_SWITCH=bm9ybWFs\x1b\\\x1b\\")
		-- 没有输出說明 Windows 25H2 的 ConPTY 核心 對來自 Neovim 進程的 \x1bP 序列做了強制過濾。這通常是因為 Neovim 在 Windows 上是以 PIPE 模式啟動的，而 ConPTY 只對真正的 TTY 句柄開放透傳。
		local conpty_passthrough = "\x1bP+p" .. osc .. "\x1b\\"
		io.stdout:write(conpty_passthrough)
		io.stdout:flush()
	else
		io.stdout:write(osc)
		io.stdout:flush()
	end
end

vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		-- vim.notify("InsertEnter fired")
		wezterm_set_user_var("IM_SWITCH", "insert")
	end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		-- vim.notify("InsertLeave fired")
		wezterm_set_user_var("IM_SWITCH", "normal")
	end,
})

-----------------------------------------------------------------
--- LspAttach 回调：所有 LSP 功能快捷键在这里设置
-----------------------------------------------------------------
-- 高亮相关的 augroup 只创建一次；光标停留时高亮符号，移动时清除
local highlight_augroup = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
local clear_highlight_augroup = vim.api.nvim_create_augroup("LspClearHighlight", { clear = true })

-- 使用 Telescope 接管全局 vim.ui.select（消灭底部简陋的 1. 2. 数字输入选择框，同时美化 gra Code Action 等）
vim.ui.select = function(items, opts, on_choice)
	opts = opts or {}
	local ok, pickers = pcall(require, "telescope.pickers")
	if not ok then
		return
	end
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local themes = require("telescope.themes")

	pickers
		.new(themes.get_dropdown({ previewer = false }), {
			prompt_title = opts.prompt or "Select",
			finder = finders.new_table({
				results = items,
				entry_maker = function(item)
					local text = opts.format_item and opts.format_item(item) or tostring(item)
					return { value = item, display = text, ordinal = text }
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if selection then
						on_choice(selection.value)
					end
				end)
				return true
			end,
		})
		:find()
end

-- 使用 Telescope 接管 LSP typeHierarchy（让 vim.lsp.buf.typehierarchy("supertypes" / "subtypes") 告别原生 Quickfix 窗口）
local function telescope_type_hierarchy_handler(title)
	return function(_, result, ctx)
		if not result or vim.tbl_isempty(result) then
			vim.notify("No " .. title .. " found", vim.log.levels.INFO)
			return
		end

		local client = vim.lsp.get_client_by_id(ctx.client_id)
		local encoding = client and client.offset_encoding or "utf-16"

		-- 只有 1 个目标时直接秒跳（与 Telescope 的 gd / gri 行为保持一致）
		if #result == 1 then
			local item = result[1]
			vim.lsp.util.show_document({
				uri = item.uri,
				range = item.selectionRange or item.range,
			}, encoding, { focus = true })
			return
		end

		-- 多个目标时弹出带代码预览的 Telescope 窗口
		local items = {}
		for _, item in ipairs(result) do
			local range = item.selectionRange or item.range
			local detail = (item.detail and #item.detail > 0) and (" " .. item.detail) or ""
			table.insert(items, {
				filename = vim.uri_to_fname(item.uri),
				lnum = range.start.line + 1,
				col = range.start.character + 1,
				text = item.name .. detail,
			})
		end

		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values
		local make_entry = require("telescope.make_entry")

		pickers
			.new({}, {
				prompt_title = title,
				finder = finders.new_table({
					results = items,
					entry_maker = make_entry.gen_from_quickfix({}),
				}),
				previewer = conf.qflist_previewer({}),
				sorter = conf.generic_sorter({}),
				push_cursor_on_edit = true,
				push_tagstack_on_edit = true,
			})
			:find()
	end
end

vim.lsp.handlers["typeHierarchy/supertypes"] = telescope_type_hierarchy_handler("LSP Supertypes")
vim.lsp.handlers["typeHierarchy/subtypes"] = telescope_type_hierarchy_handler("LSP Subtypes")

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf, remap = false }

		-- 其余全部使用 Neovim 0.11 内置最佳实践：
		-- grn (重命名), gra (Code Action，已由上方 vim.ui.select 接管为 Telescope), gO (大纲), K (悬浮文档)
		-- 基础跳转与引用：全部接入 Telescope（单个目标时直接秒跳，多个目标时弹 Telescope 预览窗）
		vim.keymap.set("n", "gd", function()
			require("telescope.builtin").lsp_definitions()
		end, vim.tbl_extend("keep", opts, { desc = "Goto definition (Telescope)" }))
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("keep", opts, { desc = "Goto declaration" }))
		vim.keymap.set("n", "gri", function()
			require("telescope.builtin").lsp_implementations()
		end, vim.tbl_extend("keep", opts, { desc = "Goto implementation (Telescope)" }))
		vim.keymap.set("n", "grs", function()
			vim.lsp.buf.typehierarchy("supertypes")
		end, vim.tbl_extend("keep", opts, { desc = "Type hierarchy: Supertypes (父类/接口)" }))
		vim.keymap.set("n", "grt", function()
			require("telescope.builtin").lsp_type_definitions()
		end, vim.tbl_extend("keep", opts, { desc = "Goto type definition (Telescope)" }))
		vim.keymap.set("n", "grr", function()
			require("telescope.builtin").lsp_references({ include_declaration = false, show_line = true })
		end, vim.tbl_extend("keep", opts, { desc = "Goto references / Find Usages (Telescope)" }))

		-- 光标停留高亮同名符号
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client.server_capabilities.documentHighlightProvider then
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = ev.buf,
				callback = vim.lsp.buf.document_highlight,
				group = highlight_augroup,
			})
			vim.api.nvim_create_autocmd("CursorMoved", {
				buffer = ev.buf,
				callback = vim.lsp.buf.clear_references,
				group = clear_highlight_augroup,
			})
		end

		-- 原生 LSP Inlay Hints（内联类型与参数名提示）：支持时默认开启，并提供 <leader>lh 随时开关
		if client and client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
			vim.keymap.set("n", "<leader>lh", function()
				local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
				vim.lsp.inlay_hint.enable(not enabled, { bufnr = ev.buf })
			end, vim.tbl_extend("keep", opts, { desc = "Toggle LSP Inlay [H]ints" }))
		end
	end,
})
