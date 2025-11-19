# set this in $PROFILE: nvim $PROFILE

function f {
    $temp = "$env:TEMP\yazi-cd.tmp"
    yazi --cwd-file $temp $args
    if (Test-Path $temp) {
        $target = Get-Content $temp
        Remove-Item $temp
        Set-Location $target
    }
}

Set-Alias -Name lg -Value 'lazygit'

$IsElevated = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($IsElevated) {
    $vsPath = "C:\Program Files\Microsoft Visual Studio\2022\Professional"
        $modulePath = "$vsPath\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
        Import-Module $modulePath
        Enter-VsDevShell -VsInstallPath $vsPath -SkipAutomaticLocation
}
