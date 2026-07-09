#!/usr/bin/env bash
# One-shot cluster bootstrap: dotfiles + mise + tools + static zsh.
# bash-only, no root required. Idempotent — safe to re-run.
#
# Usage (fresh cluster):
#   curl -fsSL https://raw.githubusercontent.com/jayghoshrao/dotfiles/master/dots.sh | bash
#   ~/bin/bootstrap-cluster.sh
# or if dotfiles are already synced (e.g. via tsync): just run this script.

# NOTE: For shared $HOME across heterogeneous ARCH, we must bootstrap multiple times locally because mise cannot cross-fetch across ARCHs.

set -euo pipefail

ARCH="$(uname -m)"
BIN_DIR="$HOME/.local/bin-$ARCH"
export MISE_ENV="$ARCH"
export MISE_DATA_DIR="$HOME/.local/share/mise-$ARCH"
export MISE_CACHE_DIR="$HOME/.cache/mise-$ARCH"

msg() { echo >&2 -e "==> ${1-}"; }
die() { echo -e "ERROR: $*" >&2; exit 1; }

check_cmd()  { command -v "$1" >/dev/null 2>&1; }
check_exe()  { [[ -x "$1" ]]; }


# mise binary (arch-specific, shared \$HOME -> arch-namespaced bin dir)
mkdir -p "$BIN_DIR"
if [[ ! -x "$BIN_DIR/mise" ]]; then
    msg "Installing mise -> $BIN_DIR/mise"
    curl -fsSL https://mise.run | MISE_INSTALL_PATH="$BIN_DIR/mise" sh
fi
export PATH="$BIN_DIR:$PATH"

# Tools from ~/.config/mise/config.toml (+ config.$ARCH.toml)
msg "Installing tools via mise"
mise install --yes

check_cmd zsh || check_exe "$HOME/.local/zsh-$ARCH/bin/zsh" || {
        msg "Installing static zsh -> ~/.local/zsh-$ARCH"
        mise run install-zsh
}

# TMUX plugins support
msg "Installing tpm"
mise run install-tpm

# Option to fetch full dots
msg "Getting dots"
mise run get-dots

msg "Done. Execute ./dots.sh [sparse|full] to clone dotfiles."
