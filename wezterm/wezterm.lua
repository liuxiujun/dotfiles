local wezterm = require 'wezterm'
wezterm.log_info("Config file loaded")
local act = wezterm.action

-- 检测操作系统，用于输入法切换命令
local is_windows = package.config:sub(1,1) == '\\'

-- 获取 Windows 上 im-select 的路径（请根据实际安装位置调整）
local im_select_path = 'C:\\Users\\liuxi\\scoop\\shims\\im-select.exe'

-- 自定义输入法 ID（英文键盘）
-- 你可以先在 PowerShell 中执行 im-select.exe，然后切换到英文输入法，再执行一次 im-select.exe 获取 ID
local english_ime_id = "1033"

-- 输入法切换函数
local function switch_to_english()
  wezterm.log_info("switch_to_english called")
  if is_windows then
    local success, stdout, stderr = wezterm.run_child_process({
      im_select_path,
      english_ime_id,
    })
    if success then
      wezterm.log_info("im-select succeeded: " .. (stdout or ""))
    else
      wezterm.log_error("im-select failed: " .. (stderr or ""))
    end
  end
end

-- ===== 输入法自动切换核心：监听 Neovim 发来的用户变量 =====
wezterm.on('user-var-changed', function(window, pane, name, value)
    wezterm.log_info("user-var-changed:" .. name .. " = " .. value)
    if name == 'IM_SWITCH' then
        if value == 'insert' then
            -- 进入插入模式：可以保持当前输入法不变（或根据需求切到中文）
            -- 这里示例进入插入模式不做切换，只退出时切英文
        elseif value == 'normal' then
            -- 离开插入模式（回到普通模式）：强制切回英文
            switch_to_english()
        end
    end
end)

-- 可选：在窗口失去焦点时也切回英文（避免在别的窗口打字还是中文）
-- wezterm.on('window-focus-changed', function(window, pane)
--     switch_to_english()
-- end)

-- 创建配置表
local config = {}

-- ===== 基础外观 =====
config.color_scheme = 'Dracula'  -- 可选：'GruvboxDark', 'Tokyo Night' 等
config.font = wezterm.font 'Cascadia Code'  -- 或 'Fira Code', 'JetBrains Mono'
config.font_size = 12.0
config.enable_tab_bar = true
-- config.window_decorations = 'RESIZE'  -- 只保留窗口边框调整
config.window_background_opacity = 1.0
-- config.hide_tab_bar_if_only_one_tab = true

-- ===== 启动设置 =====
-- config.default_prog = { 'wsl.exe', '--cd', '~' }  -- 启动 WSL（如果你用 WSL）
-- 如果不使用 WSL，可以注释上面这行，默认会启动 PowerShell 或 cmd
config.default_prog = {'pwsh.exe'}

-- ===== 键盘快捷键 =====
config.keys = {
    -- 常规复制/粘贴 (Ctrl+Shift+C / V)
    -- { key = 'C', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
    -- { key = 'V', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },

    -- 分屏 (Ctrl+Shift+ 上下左右)
    -- { key = 'UpArrow', mods = 'CTRL|SHIFT', action = act.SplitPane { direction = 'Up' } },
    -- { key = 'DownArrow', mods = 'CTRL|SHIFT', action = act.SplitPane { direction = 'Down' } },
    -- { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = act.SplitPane { direction = 'Left' } },
    -- { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.SplitPane { direction = 'Right' } },

    -- 窗格导航 (Alt+ 方向键)
    -- { key = 'UpArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
    -- { key = 'DownArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },
    -- { key = 'LeftArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
    -- { key = 'RightArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },

    -- 调整窗格大小 (Ctrl+Alt+ 方向键)
    -- { key = 'UpArrow', mods = 'CTRL|ALT', action = act.AdjustPaneSize { 'Up', 1 } },
    -- { key = 'DownArrow', mods = 'CTRL|ALT', action = act.AdjustPaneSize { 'Down', 1 } },
    -- { key = 'LeftArrow', mods = 'CTRL|ALT', action = act.AdjustPaneSize { 'Left', 1 } },
    -- { key = 'RightArrow', mods = 'CTRL|ALT', action = act.AdjustPaneSize { 'Right', 1 } },

    -- 标签页管理 (Ctrl+Shift+T 新建, Ctrl+Shift+W 关闭, Ctrl+Tab 切换)
    -- { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
    -- { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = true } },
    -- { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
    -- { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },

    -- 快速重载配置 (Ctrl+Shift+R)
    -- { key = 'R', mods = 'CTRL|SHIFT', action = act.ReloadConfiguration },

    -- 搜索模式 (Ctrl+Shift+F)
    -- { key = 'F', mods = 'CTRL|SHIFT', action = act.Search 'CurrentSelectionOrEmptyString' },
}


return config
