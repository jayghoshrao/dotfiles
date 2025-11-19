Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

scoop bucket add extras
scoop bucket add nerd-fonts

scoop install pwsh neovim ripgrep yazi lazygit fzf gcc universal-ctags alacritty wezterm FiraCode-NF Hack-NF
scoop install git

scoop install nodejs
npm install -g @github/copilot

$dotPath = "$HOME\source\repos"
$dotURL = "https://github.com/jayghoshrao/dotfiles"

cd $dotPath
git clone $dotURL

New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Local\nvim" -Target "$dotPath\dotfiles\.config\nvim"
