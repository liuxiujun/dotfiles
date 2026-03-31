-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- 使用 io.write 直接写入 stderr（WezTerm 会捕获）
-- local function wezterm_set_user_var(name, value)
-- 	local osc = string.format("\27]1337;SetUserVar=%s=%s\7", name, vim.base64.encode(value))
-- 	if vim.env.TMUX and vim.env.TMUX ~= "" then
-- 		-- tmux passthrough
-- 		local wrapped = "\27Ptmux;\27" .. osc:gsub("\27", "\27\27") .. "\27\\"
-- 		io.stdout:write(wrapped)
-- 	else
-- 		io.stdout:write(osc)
-- 	end
--
-- 	io.stdout:flush()
-- end
local function wezterm_set_user_var(name, value)
    -- 1. 对值进行 base64 编码，这是 OSC 1337 协议的强制要求
    local encoded_value = vim.base64.encode(value)
    -- 2. 构造 OSC 1337 序列
    local osc_sequence = string.format("\x1b]1337;SetUserVar=%s=%s\x07", name, encoded_value)
    
    -- 3. 处理 Tmux 环境
    if vim.env.TMUX and vim.env.TMUX ~= "" then
        local wrapped = "\x1bPtmux;\x1b" .. osc_sequence:gsub("\x1b", "\x1b\x1b") .. "\x1b\\"
        io.stdout:write(wrapped)
    else
        io.stdout:write(osc_sequence)
    end
    io.stdout:flush()
end

vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		vim.notify("InsertEnter fired")
		wezterm_set_user_var("IM_SWITCH", "insert")
	end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		vim.notify("InsertLeave fired")
		wezterm_set_user_var("IM_SWITCH", "normal")
	end,
})
