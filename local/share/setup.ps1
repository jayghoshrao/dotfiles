Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

scoop bucket add extras
scoop bucket add nerd-fonts

scoop install pwsh neovim ripgrep yazi lazygit fzf gcc universal-ctags alacritty wezterm FiraCode-NF Hack-NF
scoop install git

scoop install nodejs
npm install -g @github/copilot

$dotPathParent = "$HOME\source\repos"
$dotPath = "$dotPathParent\dotfiles"
$dotURL = "https://github.com/jayghoshrao/dotfiles"

if (-not (Test-Path $dotPath)) {
    git clone $dotURL $dotPath
}

New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Local\nvim" -Target "$dotPath\.config\nvim"

# PowerShell profile symlink
$profileSource = "$dotPath\local\share\powershell_profile.ps1"
$profileDir = Split-Path $PROFILE -Parent

if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force
}
if (Test-Path $PROFILE) {
    $backup = "$PROFILE.bak"
    Move-Item -Path $PROFILE -Destination $backup -Force
    Write-Host "Backed up existing profile to $backup"
}
New-Item -ItemType SymbolicLink -Path $PROFILE -Target $profileSource
