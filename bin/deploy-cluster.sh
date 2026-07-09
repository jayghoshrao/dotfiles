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
    .config/nvim
    bin/bootstrap-mise.sh
    # add e.g. .config/nvim if wanted on clusters
)

BOOTSTRAP=1
[[ "${1-}" == "--sync-only" ]] && { BOOTSTRAP=0; shift; }
[[ $# -ge 1 ]] || { echo "usage: ${0##*/} [--sync-only] <ssh-host>..." >&2; exit 1; }

# mise hits GitHub's unauthenticated API (60 req/hr) for every ubi/vfox tool;
# forward a token so remote installs don't get rate-limited. Same lookup
# order as _gh_token() in .bashrc.full: GITHUB_TOKEN, GH_TOKEN, gh CLI.
GITHUB_TOKEN="${GITHUB_TOKEN:-${GH_TOKEN-}}"
[[ -z "$GITHUB_TOKEN" ]] && command -v gh >/dev/null 2>&1 && GITHUB_TOKEN="$(gh auth token 2>/dev/null || true)"
[[ -z "$GITHUB_TOKEN" ]] && echo "warn: no GITHUB_TOKEN found (set env var or 'gh auth login') - remote mise installs may hit GitHub's rate limit" >&2

failed=()
for host in "$@"; do
    echo "==> $host: syncing ${#FILES[@]} files"
    if ! (cd "$HOME" && rsync -aR "${FILES[@]}" "$host":); then
        echo "==> $host: rsync failed, skipping" >&2
        failed+=("$host")
        continue
    fi
    if (( BOOTSTRAP )); then
        echo "==> $host: bootstrapping (mise + tools + zsh)"
        if ! ssh "$host" "GITHUB_TOKEN='$GITHUB_TOKEN' bash -s" <"$HOME/bin/bootstrap-mise.sh"; then
            echo "==> $host: bootstrap failed" >&2
            failed+=("$host")
        fi
    fi
done

if (( ${#failed[@]} )); then
    echo "==> failed hosts: ${failed[*]}" >&2
    exit 1
fi
