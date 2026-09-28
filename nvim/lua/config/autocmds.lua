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
-- 使用 Snacks.picker 接管 LSP typeHierarchy（让 grs 告别原生 Quickfix 简陋窗口）
local function snacks_type_hierarchy_handler(title)
	return function(_, result, ctx)
		if not result or vim.tbl_isempty(result) then
			vim.notify("No " .. title .. " found", vim.log.levels.INFO)
			return
		end

		local client = vim.lsp.get_client_by_id(ctx.client_id)
		local encoding = client and client.offset_encoding or "utf-16"

		-- 只有 1 个目标时直接秒跳
		if #result == 1 then
			local item = result[1]
			vim.lsp.util.show_document({
				uri = item.uri,
				range = item.selectionRange or item.range,
			}, encoding, { focus = true })
			return
		end

		-- 多个目标时弹出带代码预览的 Snacks.picker 窗口
		local items = {}
		for _, item in ipairs(result) do
			local range = item.selectionRange or item.range
			local detail = (item.detail and #item.detail > 0) and (" " .. item.detail) or ""
			table.insert(items, {
				file = vim.uri_to_fname(item.uri),
				pos = { range.start.line + 1, range.start.character },
				text = item.name .. detail,
			})
		end

		Snacks.picker.pick({
			title = title,
			items = items,
		})
	end
end

vim.lsp.handlers["typeHierarchy/supertypes"] = snacks_type_hierarchy_handler("LSP Supertypes")
vim.lsp.handlers["typeHierarchy/subtypes"] = snacks_type_hierarchy_handler("LSP Subtypes")

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf, remap = false }

		-- 其余全部使用 Neovim 0.11 内置最佳实践：
		-- grn (重命名), gra (Code Action，已由 snacks.picker.ui_select 自动接管), gO (大纲), K (悬浮文档)
		-- 光标停留同名符号高亮已由 snacks.words 自动接管（支持 ]] / [[ 跳转）
		-- 基础跳转与引用：全部接入 Snacks.picker（单个目标时直接秒跳，多个目标时弹预览窗）
		vim.keymap.set("n", "gd", function()
			Snacks.picker.lsp_definitions()
		end, vim.tbl_extend("keep", opts, { desc = "Goto definition (Snacks)" }))
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("keep", opts, { desc = "Goto declaration" }))
		vim.keymap.set("n", "gri", function()
			Snacks.picker.lsp_implementations()
		end, vim.tbl_extend("keep", opts, { desc = "Goto implementation (Snacks)" }))
		vim.keymap.set("n", "grs", function()
			vim.lsp.buf.typehierarchy("supertypes")
		end, vim.tbl_extend("keep", opts, { desc = "Type hierarchy: Supertypes (父类/接口)" }))
		vim.keymap.set("n", "grt", function()
			Snacks.picker.lsp_type_definitions()
		end, vim.tbl_extend("keep", opts, { desc = "Goto type definition (Snacks)" }))
		vim.keymap.set("n", "grr", function()
			Snacks.picker.lsp_references()
		end, vim.tbl_extend("keep", opts, { desc = "Goto references / Find Usages (Snacks)" }))
	end,
})
