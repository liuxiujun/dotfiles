local M = {}

-- 获取 uname 或系统名
local uname = vim.loop.os_uname()

-- 判断平台
M.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
M.is_linux = uname.sysname == "Linux" and not M.is_windows
M.is_macos = uname.sysname == "Darwin"

-- 判断是否是 WSL（Windows Subsystem for Linux）
M.is_wsl = false
if M.is_linux and uname.release:lower():find("microsoft") then
    M.is_wsl = true
end

-- 架构判断（amd64 / arm64 / i686）
local arch = uname.machine
M.is_arm = arch == "aarch64" or arch == "arm64"
M.is_amd64 = arch == "x86_64"
M.is_i386 = arch == "i386" or arch == "i686"

-- 输出结果（调试用）
-- print("System:", uname.sysname)
-- print("Release:", uname.release)
-- print("Arch:", uname.machine)

return M
