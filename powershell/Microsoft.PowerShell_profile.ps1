oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\space.omp.json" | Invoke-Expression
(&mise activate pwsh) | Out-String | Invoke-Expression
