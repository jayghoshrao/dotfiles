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
