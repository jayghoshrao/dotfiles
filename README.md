```bash
: '

                                        _       _    __ _ _
                                       | |     | |  / _(_) |
                                     __| | ___ | |_| |_ _| | ___  ___
                                    / _` |/ _ \| __|  _| | |/ _ \/ __|
                                   | (_| | (_) | |_| | | | |  __/\__ \
                                    \__,_|\___/ \__|_| |_|_|\___||___/
                                     --------------------------------          
                               Can't work with them, can't work without them
                               ---------------------------------------------


'
```

# Dotfiles

This public repo contains most of the config files that I deem useful for myself. While I've been using [GNU Stow]() so far, I've switched to using a bare repository since Stow is not available by default on most distributions. While installing it is not a _pain_ per se, the elegance of [bare git repositories](https://www.atlassian.com/git/tutorials/dotfiles) for dotfile management appealed to me more. 

A brief shout out to [Chezmoi](https://blog.lazkani.io/posts/backup/dotfiles-with-chezmoi/), which seems very interesting at first glance with its fancy templating features and encryption. In the end, I deemed it an additional dependency and translation layer that just comes in the way of my style of config management.

## Usage
```
# Clone bare repo
git clone --bare https://github.com/jayghoshter/dotfiles.git $HOME/.dots

# Use this alias for brevity
alias dot="/usr/bin/git --git-dir=$HOME/.dots --work-tree=$HOME"

# Hide untracked files
dot config --local status.showUntrackedFiles no

# Checkout worktree
dot checkout master <paths>

# Avoid recursion issues (unsure if it's actually needed)
echo ".dots" >> $HOME/.gitignore
```

For quick deployment of the essentials: `curl -fsSL https://git.io/JGBz8 | zsh`

# The Big Picture

My dev workflow is always evolving with me. This means using new tools and configurations every day. While this is no trouble on my local machine, keeping my dev environment on servers updated has been a pain.

Over time, I've learnt that there are a few "standards" I need to adopt to reduce my headaches.

## File Structure

Using a consistent directory structure is **essential**. 

```
└── home
    ├── bin             # scripts 
    ├── dev             # development
    ├── local           # install prefix
    └── repos           # cloned repos
```

## The Portable Dev Environment

I understand the value of going fully minimal and being happy with default software and configs etc, but that's not for me. I want all my keystrokes to do the same thing everywhere. In my case, this is handled with [zinit](https://github.com/zdharma/zinit).

On my local machine, I can just have a global install of whatever I want anyway. Inside an `if` clause, I pull the necessary binaries/scripts if the host is not my local machine. My whole environment is then handled by my shell -- no messy install scripts that need upkeep. Zinit is awesome. 

`zinit update` is all I need to run once in a while. I just have to ensure that I have the right zsh version installed to begin with. 

## Updating server setups

```
dot pull
zinit self-update
zinit update --parallel
nvim +PackerSync
```

Note: Sometimes `zinit delete user/repo` and a shell restart will be required if specifications are changed in the .zshrc file
