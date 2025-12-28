if (Test-Path -Path $PROFILE) {
    Remove-Item $PROFILE -Force
    # echo $PROFILE
}

$TargetPath = (Resolve-Path "$PWD\..\..\symlinks_to\pwsh_profile").Path

New-Item -ItemType SymbolicLink -Path "$PROFILE" -Target "$TargetPath\Microsoft.PowerShell_profile.ps1"
