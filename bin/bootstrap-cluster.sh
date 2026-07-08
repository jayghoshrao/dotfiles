#!/usr/bin/env bash
# One-shot cluster bootstrap: dotfiles + mise + tools + static zsh.
# bash-only, no root required. Idempotent — safe to re-run.
#
# Usage (fresh cluster):
#   curl -fsSL https://raw.githubusercontent.com/jayghoshter/dotfiles/master/dots.sh | bash
#   ~/bin/bootstrap-cluster.sh
# or if dotfiles are already synced (e.g. via tsync): just run this script.

set -euo pipefail

ARCH="$(uname -m)"
BIN_DIR="$HOME/.local/bin-$ARCH"
export MISE_ENV="$ARCH"
export MISE_DATA_DIR="$HOME/.local/share/mise-$ARCH"
export MISE_CACHE_DIR="$HOME/.cache/mise-$ARCH"

msg() { echo >&2 -e "==> ${1-}"; }

# 1. Dotfiles (skip if already bootstrapped)
if [[ ! -d "$HOME/.dots" ]]; then
    msg "Cloning dotfiles"
    curl -fsSL https://raw.githubusercontent.com/jayghoshter/dotfiles/master/dots.sh | bash
fi

# 2. mise binary (arch-specific, shared \$HOME -> arch-namespaced bin dir)
mkdir -p "$BIN_DIR"
if [[ ! -x "$BIN_DIR/mise" ]]; then
    msg "Installing mise -> $BIN_DIR/mise"
    curl -fsSL https://mise.run | MISE_INSTALL_PATH="$BIN_DIR/mise" sh
fi
export PATH="$BIN_DIR:$PATH"

# 3. Tools from ~/.config/mise/config.toml (+ config.$ARCH.toml)
msg "Installing tools via mise"
mise install --yes

# 4. Static zsh (romkatv/zsh-bin) unless a system zsh exists
if ! command -v zsh >/dev/null 2>&1 && [[ ! -x "$HOME/.local/zsh-$ARCH/bin/zsh" ]]; then
    msg "Installing static zsh -> ~/.local/zsh-$ARCH"
    mise run install-zsh
fi

msg "Done. Reconnect (or 'exec bash -l') — .bashrc execs into zsh; zinit installs plugins on first prompt."
