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

# Dotfile management
$env:DOTDIR = "$env:USERPROFILE\source\repos\dotfiles"

function dot  { git -C $env:DOTDIR @args }
function dots { git -C $env:DOTDIR status @args }
function dotc { git -C $env:DOTDIR commit --verbose @args }
function dota { git -C $env:DOTDIR add @args }
function dotu { git -C $env:DOTDIR add --update @args }
function dotd { git -C $env:DOTDIR diff @args }
function dotr { git -C $env:DOTDIR rm @args }
function dotlg { lazygit -p $env:DOTDIR }
function dotlog { git -C $env:DOTDIR log --oneline --graph @args }

Set-Alias -Name lgd -Value 'dotlg'

$IsElevated = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($IsElevated) {
    $vsPath = "C:\Program Files\Microsoft Visual Studio\2022\Professional"
        $modulePath = "$vsPath\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
        Import-Module $modulePath
        Enter-VsDevShell -VsInstallPath $vsPath -SkipAutomaticLocation
}
