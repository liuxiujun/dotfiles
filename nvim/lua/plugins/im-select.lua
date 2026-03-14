return {
    "keaising/im-select.nvim",
    -- 可选：仅在进入插入模式时加载，优化启动速度
    event = "InsertEnter",
    config = function()
        -- 1. 根据系统类型，设置默认的英文输入法 ID 和命令行工具
        local default_im = ""
        local im_command = ""

        if vim.fn.has("win32") == 1 then
            -- Windows 系统 (也包括在 WSL 中调用此配置时，但插件在 WSL 内运行，判断结果会是 Unix)
            -- 注意：这个分支主要针对原生 Windows Neovim
            default_im = "1033" -- 1033 是美式英语的 locale ID [citation:2][citation:5]
            im_command = "im-select.exe"
        elseif vim.fn.has("unix") == 1 then
            -- Unix-like 系统，包括 WSL2 和 Ubuntu
            -- 进一步判断是否是 WSL
            local is_wsl = vim.fn.filereadable("/proc/sys/fs/binfmt_misc/WSLInterop") or
                           vim.fn.filereadable("/proc/sys/fs/binfmt_misc/WSLInterop-late")
            if is_wsl then
                -- 在 WSL2 中，我们调用 Windows 的 exe 程序
                default_im = "1033"
                -- 方法1：如果 im-select.exe 在 WSL 的 PATH 中 (例如 /mnt/c/Users/你的用户名/bin 或通过ln -s链接)
                im_command = "im-select.exe"
                -- 方法2：如果不在 PATH 中，可以指定绝对路径，例如：
                -- im_command = "/mnt/c/path/to/your/im-select.exe"
            else
                -- 原生 Linux (如 Ubuntu)
                -- 这里以 Fcitx5 为例，你需要根据自己使用的输入法调整
                default_im = "keyboard-us" -- Fcitx5 的默认英文键盘 [citation:1]
                im_command = "fcitx5-remote"
                -- 如果你使用 IBus，可能是：
                -- default_im = "xkb:us::eng"
                -- im_command = "ibus"
            end
        elseif vim.fn.has("mac") == 1 then
            -- macOS 系统
            default_im = "com.apple.keylayout.ABC" -- 美式英语 [citation:1][citation:2][citation:5]
            im_command = "macism"
        end

        -- 2. 插件初始化，传入配置
        require("im_select").setup({
            default_im_select = default_im,
            default_command = im_command,
            -- 其他配置选项，根据你的喜好调整
            set_default_events = { "InsertLeave", "CmdlineLeave" }, -- 离开插入/命令行模式时切换回英文
            set_previous_events = { "InsertEnter" },                -- 进入插入模式时恢复上次使用的输入法
            keep_quiet_on_no_binary = false,                        -- 找不到命令时提示
            async_switch_im = true,                                  -- 异步切换，防止卡顿
        })
    end,
}
