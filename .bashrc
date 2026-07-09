# vim: fdm=marker
# ~/.bashrc — thin shim: exec into zsh for interactive shells.
#
# The full interactive config lives in ~/.zshrc (zinit plugins, prompt, fzf).
# On bash-only clusters, `mise run install-zsh` puts a statically-linked zsh
# (romkatv/zsh-bin) into ~/.local/zsh-$(uname -m); we exec that here so the
# zsh setup works everywhere without root or chsh.
#
# Escape hatch: NO_ZSH=1 bash  -> stay in bash with the minimal fallback below.
# Full bash port (pre-shim) preserved at ~/.bashrc.bak.20260708.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Exec zsh: {{{
# Shared $HOME: `command -v zsh` can resolve to the other arch's
# ~/.local/zsh-*/bin/zsh left on PATH by `srun --export=ALL`, and [[ -x ]]
# alone doesn't catch the wrong ELF arch (Exec format error). Skip
# wrong-arch dirs and probe that the binary actually runs before exec.
if [[ -z "$NO_ZSH" && -z "$ZSH_VERSION" ]]; then
    _arch="$(uname -m)"
    for _z in "$HOME/.local/zsh-$_arch/bin/zsh" "$(command -v zsh)"; do
        case "$_z" in
            "$HOME/.local/zsh-$_arch/"*) ;;
            "$HOME/.local/zsh-"*) continue ;;
        esac
        if [[ -x "$_z" ]] && "$_z" -fc 'exit' 2>/dev/null; then
            export SHELL="$_z"
            exec "$_z" -l
        fi
    done
    unset _z _arch
fi
# Exec zsh: }}}

# ---- Minimal fallback (no zsh found, or NO_ZSH=1) ----

stty -ixon 2>/dev/null   # Disable ctrl-s/ctrl-q flow control

# Helpers: {{{
_has() { command -v "$1" >/dev/null 2>&1; }

prependToEnv() {
    case ":$(printenv "$1"):" in
        *":$2:"*) : ;;                                   # already there
        *) export "$1"="$2:$(printenv "$1")" ;;
    esac
}
appendToEnv() {
    case ":$(printenv "$1"):" in
        *":$2:"*) : ;;                                   # already there
        *) export "$1"="$(printenv "$1"):$2" ;;
    esac
}
# }}}

# PATH / arch hygiene: {{{
# Shared $HOME across architectures: a PATH inherited from a different-arch
# node (e.g. an x86 login node -> an arm compute node under `srun --export=ALL`)
# leaves the wrong arch's bin dir on PATH, where its binaries shadow ours and
# fail to exec. Drop any ~/.local/bin-* that isn't this machine's BIN_DIR, then
# put BIN_DIR first.
export BIN_DIR="$HOME/.local/bin-$(uname -m)"
[[ -d "$BIN_DIR" ]] || mkdir -p "$BIN_DIR"

_clean_other_arch_path() {
    local newp= entry
    local -a parts
    IFS=: read -r -a parts <<< "$PATH"
    for entry in "${parts[@]}"; do
        [[ -z "$entry" ]] && continue
        case "$entry" in
            "$HOME/.local/bin-"*) [[ "$entry" == "$BIN_DIR" ]] || continue ;;
        esac
        newp="${newp:+$newp:}$entry"
    done
    export PATH="$newp"
}
_clean_other_arch_path
prependToEnv PATH "$BIN_DIR"
prependToEnv PATH "$HOME/.local/bin"
[[ -d "$HOME/bin" ]] && appendToEnv PATH "$HOME/bin"
# }}}

# mise: {{{
# Tools come from mise (~/.config/mise/config.toml), arch-namespaced for the
# shared-$HOME clusters. Mirrors the block in ~/.zshrc.
export MISE_ENV="$(uname -m)"
export MISE_DATA_DIR="$HOME/.local/share/mise-$MISE_ENV"
export MISE_CACHE_DIR="$HOME/.cache/mise-$MISE_ENV"
for _mise in "$HOME/.nix-profile/bin/mise" "$BIN_DIR/mise" "$(command -v mise)"; do
    if [[ -x "$_mise" ]]; then
        eval "$("$_mise" activate bash)"
        break
    fi
done
unset _mise
# }}}

# Completion + fzf: {{{
[[ -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

if _has fzf; then
    eval "$(fzf --bash 2>/dev/null)" || {
        [[ -f /usr/share/doc/fzf/examples/key-bindings.bash ]] && . /usr/share/doc/fzf/examples/key-bindings.bash
    }
fi
# }}}

# Prompt: {{{
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# }}}

# Basics: {{{
export EDITOR=$(command -v nvim || command -v vim || command -v vi)
alias vim="$EDITOR"
alias ls='ls --color=auto'
alias ll='ls -lah'
alias grep='grep --color=auto'
HISTSIZE=100000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth
shopt -s histappend checkwinsize
# }}}
