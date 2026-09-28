--------------------------------------------------------------------------------
-- 插件名称：keaising/im-select.nvim
-- 功能用途：本地输入法自动切换（退出 Insert 模式切回英文，进入 Insert 模式恢复原输入法）
-- 状态说明：当前默认禁用（enabled = false），因为主力终端 WezTerm 已在 autocmds.lua 中接管；
--           若在非 WezTerm 终端或新设备上使用，只需将下方 enabled 改为 true 即可一键启用。
--------------------------------------------------------------------------------
return {
	"keaising/im-select.nvim",
	enabled = false, -- 按需启用：设为 false 时 lazy.nvim 不会加载或下载该插件
	event = "InsertEnter",
	config = function()
		local default_im = ""
		local im_command = ""

		if vim.fn.has("win32") == 1 then
			default_im = "1033" -- 美式英语 locale ID
			im_command = "im-select.exe"
		elseif vim.fn.has("unix") == 1 then
			local is_wsl = vim.fn.filereadable("/proc/sys/fs/binfmt_misc/WSLInterop") == 1
				or vim.fn.filereadable("/proc/sys/fs/binfmt_misc/WSLInterop-late") == 1
			if is_wsl then
				default_im = "1033"
				im_command = "im-select.exe"
			else
				-- 原生 Linux (以 Fcitx5 为例)
				default_im = "keyboard-us"
				im_command = "fcitx5-remote"
			end
		elseif vim.fn.has("mac") == 1 then
			default_im = "com.apple.keylayout.ABC"
			im_command = "macism"
		end

		require("im_select").setup({
			default_im_select = default_im,
			default_command = im_command,
			set_default_events = { "InsertLeave", "CmdlineLeave" },
			set_previous_events = { "InsertEnter" },
			keep_quiet_on_no_binary = true, -- 找不到 im-select 二进制文件时静默跳过，不弹报错
			async_switch_im = true,
		})
	end,
}
