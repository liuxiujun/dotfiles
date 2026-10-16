oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\space.omp.json" | Invoke-Expression
(&mise activate pwsh) | Out-String | Invoke-Expression

# 每次渲染提示符时将窗口标题重置为当前目录名或 pwsh
$originalPrompt = $function:prompt
function prompt {
    $host.UI.RawUI.WindowTitle = (Split-Path -Leaf (Get-Location))
    & $originalPrompt
}
