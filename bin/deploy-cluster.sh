#!/usr/bin/env bash
# Push the core shell setup to clusters WITHOUT the dotfiles repo:
# rsync exactly these files, then run the bootstrap remotely
# (mise binary + tools + static zsh). Idempotent.
#
# Usage: deploy-cluster.sh <ssh-host> [<ssh-host>...]
#        deploy-cluster.sh --sync-only <ssh-host>   # skip remote bootstrap

set -euo pipefail

FILES=(
    .zshrc
    .zsh-fzf
    .bashrc
    .tmux.conf
    .config/mise/config.toml
    .config/mise/config.x86_64.toml
    bin/bootstrap-cluster.sh
    # add e.g. .config/nvim if wanted on clusters
)

BOOTSTRAP=1
[[ "${1-}" == "--sync-only" ]] && { BOOTSTRAP=0; shift; }
[[ $# -ge 1 ]] || { echo "usage: ${0##*/} [--sync-only] <ssh-host>..." >&2; exit 1; }

for host in "$@"; do
    echo "==> $host: syncing ${#FILES[@]} files"
    (cd "$HOME" && rsync -aR "${FILES[@]}" "$host":)
    if (( BOOTSTRAP )); then
        echo "==> $host: bootstrapping (mise + tools + zsh)"
        ssh "$host" 'bash ~/bin/bootstrap-cluster.sh'
    fi
done
