-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

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
