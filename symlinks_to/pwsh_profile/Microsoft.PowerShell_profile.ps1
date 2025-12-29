# note this link has to be in windows file system
oh-my-posh init pwsh | Invoke-Expression

function updates_all {
    $stamp = "$env:USERPROFILE\.last_update_winget"
    $today = (Get-Date).ToString('yyyy-MM-dd')
    if (Test-Path $stamp) {
        $lastDate = Get-Content $stamp
        if ($lastDate -eq $today) {
            Write-Host "📦 Winget already updated today"
            return
        }
    }
    Write-Host "📦 Updating Winget packages..."
    winget upgrade --all --accept-source-agreements
    Write-Host "🧹 Cleaning up..."
    $today | Set-Content $stamp
    Write-Host "✅ done"
}

updates_all
clear
fastfetch
