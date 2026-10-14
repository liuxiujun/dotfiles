# ============================================================================
# dotfiles 交互式初始化（Windows）
# 用法：
#   powershell -NoProfile -ExecutionPolicy Bypass -File setup.ps1     # 交互式
#   ... -File setup.ps1 -List                                         # 只看计划
#   ... -File setup.ps1 -All                                          # 全部建立
#   ... -File setup.ps1 -Force                                        # 替换冲突项
# 所有链接的目标位置以脚本自身位置（仓库根）推导，与用户名无关
# ============================================================================
[CmdletBinding()]
param(
    [switch]$All,
    [switch]$List,
    [switch]$Force,
    [string]$HomeDir = $HOME
)

$ErrorActionPreference = 'Stop'
$Repo = $PSScriptRoot
if (-not $Repo) { $Repo = Split-Path -Parent $MyInvocation.MyCommand.Path }

if ($PSVersionTable.Platform -and $PSVersionTable.Platform -ne 'Win32NT') {
    Write-Host "本脚本面向 Windows，Linux/macOS 请使用 ./setup.sh" -ForegroundColor Yellow
    exit 1
}

# key 唯一标识；link 相对 $HomeDir；target 相对 $Repo
$Manifest = @(
    @{ key = 'git';     desc = 'Git 配置';            link = '.gitconfig';                                    target = 'git\.gitconfig';                          type = 'file' }
    @{ key = 'ssh';     desc = 'SSH 配置';            link = '.ssh\config';                                   target = 'ssh\config';                              type = 'file' }
    @{ key = 'wezterm'; desc = 'WezTerm 终端';        link = '.config\wezterm';                               target = 'wezterm';                                 type = 'dir' }
    @{ key = 'pwsh';    desc = 'PowerShell profile';  link = 'Documents\PowerShell\Microsoft.PowerShell_profile.ps1'; target = 'powershell\Microsoft.PowerShell_profile.ps1'; type = 'file' }
    @{ key = 'vim';     desc = 'Vim 配置 (vimfiles)'; link = 'vimfiles';                                      target = 'vim';                                     type = 'dir' }
    @{ key = 'nvim';    desc = 'Neovim 配置';         link = 'AppData\Local\nvim';                            target = 'nvim';                                    type = 'dir' }
    @{ key = 'ideavim'; desc = 'IntelliJ IdeaVim';    link = '.ideavimrc';                                    target = '.ideavimrc';                              type = 'file' }
    @{ key = 'vrapper'; desc = 'Eclipse vrapper';     link = '.vrapperrc';                                    target = '.vrapperrc';                              type = 'file' }
    @{ key = 'wsl';     desc = 'WSL2 配置';           link = '.wslconfig';                                    target = '.wslconfig';                              type = 'file' }
    @{ key = 'vind';    desc = 'win-vind';            link = '.win-vind\.vindrc';                             target = '.vindrc';                                 type = 'file' }
    @{ key = 'npm';     desc = 'NPM 配置';            link = '.npmrc';                                        target = '.npmrc';                                  type = 'file' }
    @{ key = 'mpv';     desc = 'mpv 按键配置';        link = '.config\mpv\input.conf';                        target = 'mpv\input.conf';                          type = 'file' }
)

function Get-LinkState([string]$LinkPath, [string]$TargetPath) {
    if (-not (Test-Path -LiteralPath $LinkPath)) { return 'missing' }
    $item = Get-Item -LiteralPath $LinkPath -Force
    if ($item.LinkType) {
        $t = @($item.Target)[0]
        if ($t -and ((Resolve-Path -LiteralPath $t).Path -ieq (Resolve-Path -LiteralPath $TargetPath).Path)) { return 'ok' }
        return 'conflict'
    }
    # 无 LinkType 的普通文件：可能是不带标记的硬链接（fsutil 校验）
    if ($item.PSIsContainer) { return 'conflict' }
    $links = @(& fsutil.exe hardlink list $LinkPath 2>$null | Where-Object { $_ -is [string] })
    $targetResolved = (Resolve-Path -LiteralPath $TargetPath).Path
    $hit = @($links | Where-Object { $_.Trim() -ieq $targetResolved })
    if ($LASTEXITCODE -eq 0 -and $hit.Count -gt 0) { return 'ok' }
    return 'conflict'
}

function New-Link([string]$LinkPath, [string]$TargetPath, [string]$Type) {
    $parent = Split-Path -Parent $LinkPath
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    try {
        New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath | Out-Null
        return 'symlink'
    } catch [System.UnauthorizedAccessException] {
        # 无管理员权限时的降级链：目录→Junction（无需权限）；文件→硬链接（同卷无需权限）
        if ($Type -eq 'dir') {
            New-Item -ItemType Junction -Path $LinkPath -Target $TargetPath | Out-Null
            return 'junction'
        } else {
            New-Item -ItemType HardLink -Path $LinkPath -Target $TargetPath | Out-Null
            return 'hardlink'
        }
    }
}

function Write-GitPlatform {
    # .gitconfig-platform：机器本地（gitignore），include 采用部署时推导的绝对路径
    # 注释用 ASCII：gitconfig 文件避免任何编码歧义
    $platform = Join-Path $Repo 'git\.gitconfig-platform'
    $winConf = (Join-Path $Repo 'git\.gitconfig-windows.conf') -replace '\\', '/'
    "# Generated by setup.ps1 (machine-local, do not commit)`n[include]`n    path = $winConf`n" |
        Set-Content -Path $platform -Encoding ASCII
    Write-Host "  -> 已生成 git\.gitconfig-platform -> .gitconfig-windows.conf" -ForegroundColor DarkGray
}

# ---- 状态展示 ----
Write-Host "`ndotfiles 初始化（仓库: $Repo -> HOME: $HomeDir）`n" -ForegroundColor Cyan
$i = 0
foreach ($m in $Manifest) {
    $i++
    $linkPath = Join-Path $HomeDir $m.link
    $targetPath = Join-Path $Repo $m.target
    $state = if (Test-Path -LiteralPath $targetPath) { Get-LinkState $linkPath $targetPath } else { 'no-target' }
    $mark = switch ($state) {
        'ok'        { '[已链接]' ; break }
        'conflict'  { '[冲突!]' ; break }
        'missing'   { '[未建立]' ; break }
        default     { '[仓库缺失]' }
    }
    $color = switch ($state) { 'ok' { 'DarkGreen' } 'conflict' { 'Red' } default { 'Gray' } }
    Write-Host ("  {0,2}. {1,-12} {2}  {3}" -f $i, $m.key, $mark, $m.desc) -ForegroundColor $color
}

if ($List) { exit 0 }

# ---- 选择 ----
if ($All) {
    $selected = $Manifest
} else {
    $ans = Read-Host "`n选择要建立的项（如 1,3,5；a=全部；直接回车=逐项确认；q=退出）"
    if ($ans -eq 'q') { exit 0 }
    if ($ans -eq 'a') {
        $selected = $Manifest
    } elseif ([string]::IsNullOrWhiteSpace($ans)) {
        $selected = @()
        foreach ($m in $Manifest) {
            $y = Read-Host ("  建立 {0} ({1})? [Y/n] " -f $m.key, $m.desc)
            if ($y -notmatch '^(n|N)') { $selected += $m }
        }
    } else {
        $nums = $ans -split '[,\s]+' | Where-Object { $_ -match '^\d+$' }
        $selected = @(); foreach ($n in $nums) { $idx = [int]$n - 1; if ($idx -ge 0 -and $idx -lt $Manifest.Count) { $selected += $Manifest[$idx] } }
    }
}

# ---- 执行 ----
$created = 0; $skipped = 0; $failed = 0
foreach ($m in $selected) {
    $linkPath = Join-Path $HomeDir $m.link
    $targetPath = Join-Path $Repo $m.target
    if (-not (Test-Path -LiteralPath $targetPath)) {
        Write-Host "[失败] $($m.key): 仓库中不存在 $($m.target)" -ForegroundColor Red; $failed++; continue
    }
    $state = Get-LinkState $linkPath $targetPath
    if ($state -eq 'ok') { Write-Host "[跳过] $($m.key): 已是正确链接" -ForegroundColor DarkGreen; $skipped++; continue }
    if ($state -eq 'conflict' -and -not $Force) {
        Write-Host "[冲突] $($m.key): $linkPath 已存在且不是指向本仓库（-Force 替换）" -ForegroundColor Red; $failed++; continue
    }
    if ($state -eq 'conflict' -and $Force) {
        Remove-Item -LiteralPath $linkPath -Force -Recurse
    }
    try {
        $kind = New-Link $linkPath $targetPath $m.type
        Write-Host "[建立] $($m.key): $($m.link) -> $($m.target) ($kind)" -ForegroundColor Green
        $created++
        if ($m.key -eq 'git') { Write-GitPlatform }
    } catch {
        Write-Host "[失败] $($m.key): $($_.Exception.Message)" -ForegroundColor Red; $failed++
    }
}

Write-Host "`n完成：建立 $created，跳过 $skipped，失败/冲突 $failed`n" -ForegroundColor Cyan
Write-Host "后续手动步骤（按需）：" -ForegroundColor Yellow
Write-Host "  Vim 插件引导:  iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | ni $HomeDir\vimfiles\autoload\plug.vim -Force"
Write-Host "  然后 vim 内 :PlugInstall（或 vim -S plug-snapshot.vim 按锁定版本安装）"
Write-Host "  IDEA 插件: IdeaVim / AceJump / IdeaVim-EasyMotion / Which-Key"
