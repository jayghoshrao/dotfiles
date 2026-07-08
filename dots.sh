#!/usr/bin/env bash
# Bootstrap the dotfiles bare repo into $HOME.
# bash (not zsh): must run on bash-only clusters before zsh exists.

set -euo pipefail

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

[[ -x "$(command -v git)" ]] || die "git is not installed!"

DOT_DIR="$HOME/.dots"
MODE=${1:-"sparse"}
SPARSE=( '.zshrc' '.zsh-fzf' '.bashrc' '.tmux.conf' '.config/mise/*' '.config/nvim/*' '.config/nnn/*' '.terminfo/*' 'bin/*' )

# Clone bare repo. Skip without error if dir exists.
[ -d "$DOT_DIR" ] || git clone --bare https://github.com/jayghoshter/dotfiles.git "$DOT_DIR"

dot() {
  git --git-dir="$DOT_DIR" --work-tree="$HOME" "$@"
}

# Hide untracked files
dot config --local status.showUntrackedFiles no

# Avoid recursion issues (unsure if it's actually needed)
echo "${DOT_DIR##$HOME/}" >> "$HOME"/.gitignore

if [[ $MODE == "full" ]]; then
    echo "Checkout mode: full"
    dot config core.sparsecheckout false
    dot checkout master
elif [[ $MODE == "sparse" ]]; then
    echo "Checkout mode: sparse"
    dot config core.sparsecheckout true
    # TODO: Make this idempotent
    dot ls-tree --name-only HEAD | sed 's/^/# /' > "$DOT_DIR"/info/sparse-checkout
    tmp=( "${@:2}" )
    arr=( "${tmp[@]:-${SPARSE[@]}}" )
    for file in "${arr[@]}"; do
        echo "$file" >> "$DOT_DIR"/info/sparse-checkout
    done
    dot read-tree -m -u HEAD
elif [[ $MODE == "bare" ]]; then
    echo "Checkout mode: bare"
    dot config core.sparsecheckout true
    dot ls-tree --name-only HEAD | sed 's/^/# /' > "$DOT_DIR"/info/sparse-checkout
    dot read-tree -m -u HEAD
fi
