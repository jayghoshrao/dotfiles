# vim: fdm=marker
#                  ██     
#                 ░██     
#   ██████  ██████░██     
#  ░░░░██  ██░░░░ ░██████ 
#     ██  ░░█████ ░██░░░██
#    ██    ░░░░░██░██  ░██
#   ██████ ██████ ░██  ░██
#  ░░░░░░ ░░░░░░  ░░   ░░ 
#
#  ~/.zsh-fzf
#  ~/.zsh-local
#
#  Might wanna add `export XDG_CURRENT_DESKTOP=GNOME` to /etc/profile on fresh installs

stty -ixon                                                       # Disables ctrl-s/ctrl-q

ARCH=$(uname -a | awk '{print $(NF-1)}')

# # autoload -U +X bashcompinit && bashcompinit

## NOTE: Uncomment in case compaudit complains of insecure directories
# autoload -U +X compinit && compinit -i

if [ $HOST = "IBT918" ]; then
    autoload -Uz compinit; compinit
    compdef '_files -W $NOTES_DIR' note
    compdef '_files -W $NOTES_DIR' notes
    compdef '_files -W ~/bin/' se
fi

# Package Manager: {{{

# ZINIT: {{{
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node

### End of Zinit's installer chunk

### Functions to make zinit configuration less verbose
zpt() { zinit ice wait"${1}" lucid               "${@:2}"; } # Turbo
zpi() { zinit ice lucid                            "${@}"; } # Regular Ice
zp()  { [ -z $2 ] && zinit light $@ || zinit $@; } # zinit

zinit snippet OMZL::directories.zsh 
zinit snippet OMZL::termsupport.zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZP::git

# Other OMZ options
# zinit wait lucid for \ OMZL::git.zsh \ OMZL::clipboard.zsh \ OMZL::grep.zsh \ OMZL::history.zsh \ OMZL::spectrum.zsh \ OMZP::git \ OMZP::fzf 

zpt 0b blockf
zp zsh-users/zsh-completions

zpt 0a lucid atload"_zsh_autosuggest_start"
zp zsh-users/zsh-autosuggestions

# ## Remove the the next line if compaudit complains of insecurity 
zpt 0b atload'zpcompinit;zpcdreplay'
# zpt 0b atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zp zdharma-continuum/fast-syntax-highlighting

if [[ "$ARCH" == "x86_64" ]]; then


    zpi from"gh-r" as"command"
    zp junegunn/fzf

    zpt '0c' as"command" id-as"junegunn/fzf-tmux" pick"bin/fzf-tmux"
    zp junegunn/fzf

    zpt '0c' multisrc"shell/{completion,key-bindings}.zsh" id-as"junegunn/fzf_completions" pick"/dev/null"
    zp junegunn/fzf

    zp Aloxaf/fzf-tab

    if [ $HOST != "IBT918" ]; then
        # RIPGREP:{{{
        zpi from"gh-r" as"program" mv"ripgrep* -> ripgrep" pick"ripgrep/rg"
        zp BurntSushi/ripgrep
        # }}}
        # NEOVIM: {{{
        zpi from"gh-r" as"program" bpick"*appimage*" ver"stable" mv"nvim* -> nvim" pick"nvim"
        zp neovim/neovim
        # }}}
        # FD: {{{
        zpi as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
        zp sharkdp/fd
        # }}}
        # GH-CLI: {{{
        zpt "0" as"program" from"gh-r" pick"usr/bin/gh"
        zp "cli/cli"
        # }}}
        # TMUX: {{{
        zpi from"gh-r" as"program" mv"tmux* -> tmux" pick"tmux" atload"alias tmux=tmux"
        zp tmux/tmux
        # }}}
        # NNN: {{{
        zpi from"gh-r" as"program" mv"nnn* -> nnn" bpick"nnn-static*"
        zp jarun/nnn
        # }}}
    fi
fi

# Theme and Colors {{{

zinit for \
    light-mode pick"async.zsh" src"pure.zsh" \
    sindresorhus/pure

# For GNU ls (the binaries can be gls, gdircolors, e.g. on OS X when installing the
# coreutils package from Homebrew; you can also use https://github.com/ogham/exa)
zinit ice atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!'
zinit light trapd00r/LS_COLORS

zinit light 'chrissicool/zsh-256color'
zinit ice atclone"dircolors -b src/dir_colors > c.zsh" \
            atpull'%atclone' \
            pick"c.zsh" \
            nocompile'!'
zinit light arcticicestudio/nord-dircolors

# }}}


# }}}

# ## Remote OMZ setup
# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="avit" #Look in $OMZ/themes
# plugins=(git vi-mode zsh-autosuggestions zsh-syntax-highlighting )
# source $ZSH/oh-my-zsh.sh
# source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# source $ZSH_CUSTOM/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Package Manager: }}}

# Bindkeys: {{{
# Allow v to edit the command line
bindkey -v                                                       # vim mode in shell 
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

bindkey '  ' autosuggest-accept
bindkey '^ ' autosuggest-clear
bindkey '^ ' kill-line
bindkey '^s' vi-forward-blank-word
bindkey '^v' vi-backward-blank-word
bindkey '^p' up-history
bindkey '^n' down-history

bindkey -M vicmd 'H' beginning-of-line
bindkey -M vicmd 'L' end-of-line
bindkey '^[[Z' reverse-menu-complete                             # shift-tab reverse selection direction


## Bindkeys: }}}

# setopts: {{{

setopt MENU_COMPLETE
setopt promptsubst

setopt BANG_HIST                 # Don't treat '!' specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt APPEND_HISTORY            # Appends history to history file on exit
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing non-existent history.

## Directories
DIRSTACKSIZE=9
setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt MULTIOS              # Write to multiple descriptors.
setopt EXTENDED_GLOB        # Use extended globbing syntax.
unsetopt GLOB_DOTS
unsetopt AUTO_NAME_DIRS     # Don't add variable-stored paths to ~ list




## Jobs
setopt LONG_LIST_JOBS     # List jobs in the long format by default.
setopt AUTO_RESUME        # Attempt to resume existing job before creating a new process.
setopt NOTIFY             # Report status of background jobs immediately.
unsetopt BG_NICE          # Don't run all background jobs at a lower priority.
unsetopt HUP              # Don't kill jobs on shell exit.
unsetopt CHECK_JOBS       # Don't report on jobs when shell exit.

# setopts: }}}

# Basics:{{{

function! prependToEnv()
{
    case ":$(printenv $1):" in
        *":$2:"*) :;; # already there
        *) export $1="$2:$(printenv $1)";;
    esac
}

function! appendToEnv()
{
    case ":$(printenv $1):" in
        *":$2:"*) :;; # already there
        *) export $1="$(printenv $1):$2";; 
    esac
}


# if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
#     source /etc/profile.d/vte.sh
# fi

[ -f ~/.zsh-local ] && source ~/.zsh-local
[ -f ~/.zsh-fzf ] && source ~/.zsh-fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#}}}

# zstyle completions: {{{

# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:vim:*:*files' ignored-patterns '*.o'
zstyle ':completion:*:*:nvim:*:*files' ignored-patterns '*.o'

zstyle '*' single-ignored complete
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' \
  max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
# Have the completion system announce what it is completing
# zstyle ':completion:*' format 'Completing %d'
# In menu-style completion, give a status bar
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# zstyle ':completion:*' completer _expand _complete _ignored _approximate
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# zstyle ':completion:*' menu select=2
# zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
# zstyle ':completion:*:descriptions' format '-- %d --'
# zstyle ':completion:*:processes' command 'ps -au$USER'
# zstyle ':completion:complete:*:options' sort false
# zstyle ':fzf-tab:complete:_zlua:*' query-string input
# zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
# zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap
# zstyle ":completion:*:git-checkout:*" sort false
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}


# }}}

# Exports: {{{

ZSH_TMUX_AUTOCONNECT=true
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=100000
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=120000  # Larger than $SAVEHIST for HIST_EXPIRE_DUPS_FIRST to work
SAVEHIST=100000
LISTMAX=9999    # In the line editor, number of matches to show before asking permission

DISABLE_UNTRACKED_FILES_DIRTY="true"
export TERM="xterm-256color-italic"
export LESS="-iR"

export NNN_FIFO=/tmp/nnn.fifo 
export NNN_OPTS="exaAE"
export NNN_COLORS="2136" ## Different colors for contexts 
export NNN_PLUG='g:getplugs;c:fuznavconf;f:fuznav;i:imgview;d:diffs'
export LC_COLLATE="C" ## dot files clumped together

## Exports: }}}

command -v nvim >/dev/null && export EDITOR='nvim' || export EDITOR='vim'
command -v nvim >/dev/null && alias vim="nvim" vimdiff="nvim -d" # Use neovim for vim if present.

#Alias {{{

alias i3c="dotf $HOME/.config/i3/config"
alias zc="dotf $HOME/.zshrc"
alias zcf="dotf $HOME/.zsh-fzf"
alias zcl="$EDITOR ~/.zsh-local"
# alias nrc="dotf $HOME/.config/nvim/init.vim"
alias nrc="$EDITOR $HOME/.config/nvim/init.lua +'lcd %:p:h'"
alias zz="source $HOME/.zshrc"

alias n="notes"
alias nn="note"
alias ns="notesearch"
alias fns="fnotesearch"

alias nd="notes -d $HOME/Dropbox/DND"
alias ndn="note -d $HOME/Dropbox/DND"
# alias nd="ls --group-directories-first $NOTES_DIR"

alias t="thesaurus"
alias gj="git-jump"
alias fu="findup.py"

# alias -g ff="fuzscope | filer"
alias -g ff="fuzscope | peek"
alias -g G='| grep -i'  ## Global alias
alias -g F='| fzf'  ## Global alias
alias -g X='>/dev/null 2>&1 & disown'
alias -g T='|& tee'
alias -g TL='|& tee out.log'
alias -g L='| less'

alias d='dirs -v | head -10'

alias ls='ls --color -v'
alias la='ls -la --color -v'
# alias ll='ls -la --color --group-directories-first'
alias ll='exa --long --all --links --git --git-ignore'

# Open modified files
# ACMR = Added || Copied || Modified || Renamed
alias vd="$EDITOR \$(git diff HEAD --name-only --diff-filter=ACMR)"
alias vds="$EDITOR \$(git diff --staged --name-only --diff-filter=ACMR)"
alias vdc="$EDITOR \$(git diff HEAD^ --name-only --diff-filter=ACMR)"
alias vdd="$EDITOR \$(git diff develop --name-only --diff-filter=ACMR)"

alias stj="ssh -qTfnN2 -D 8086 ibt014"

# alias f=". nnnwrap"

alias val='valgrind -v --leak-check=full --show-leak-kinds=all --track-origins=yes --show-reachable=yes'

#}}}

# Functions {{{

# xdg-open:{{{
xo()
{
	arg=""
	for value in "$@"; do
		arg="$arg$value"
	done
    nohup xdg-open "$arg" >/dev/null 2>&1 & disown
}
#}}}
# eXecute: {{{
x()
{
	# arg=""
	# for value in $@; do
	# 	arg="$arg$value"
	# done
    nohup "$@" >/dev/null 2>&1 & disown
}
#}}}
#CHT.SH:{{{
function cht()
{
    curl cht.sh/$1
}
#}}}
# C-Z: {{{
fgkey() { fg }
zle -N fgkey
bindkey '^Z' fgkey
# }}}
#panwebmark: {{{
# Pandoc convert web html to markdown
function pwm()
{
    curl --silent "$1" | pandoc --wrap=preserve --strip-comments --reference-links --from html-raw_html --to markdown_strict -o "$2"
    sed -i '0,/===/d' "$2"
    sed -i '/-----/,$d' "$2"
}
#}}}
# vimwhich - vimw: {{{
vimw()
{
    vim $(readlink -f $(which "$@"))
}
# }}}
# vim-rg-to-quickfix:{{{
function! vq()
{
    nvim -q <( rg -S --vimgrep "$@" )
}
# }}}
# mkc: {{{
function mkc()
{
    mkdir "$1" && cd "$1"
}
# }}}
# yank-path and yank-dirs: {{{
function yp() {echo "$PWD/$1" | tr -d '\n' | xclip -i -selection clipboard}
function yd() {echo "$PWD" | tr -d '\n' | xclip -i -selection clipboard}
#}}}
# MAN: {{{

function man() {

# LESS_TERMCAP_mb # blinking mode (not common in manpages)
# LESS_TERMCAP_md # double-bright mode (used for boldface)
# LESS_TERMCAP_me # exit/reset all modes
# LESS_TERMCAP_so # enter standout mode (used by the less statusbar and search results)
# LESS_TERMCAP_se # exit standout mode
# LESS_TERMCAP_us # enter underline mode (used for underlined text)
# LESS_TERMCAP_ue # exit underline mode

    env \
    LESS_TERMCAP_mb="$(printf "\e[1;31m")" \
    LESS_TERMCAP_md="$(printf "\e[1;31m")" \
    LESS_TERMCAP_me="$(printf "\e[0m")" \
    LESS_TERMCAP_se="$(printf "\e[0m")" \
    LESS_TERMCAP_so="$(printf "\e[1;44;33m")" \
    LESS_TERMCAP_ue="$(printf "\e[0m")" \
    LESS_TERMCAP_us="$(printf "\e[1;32m")" \
    man "${@}"
}
# MAN: }}}
# ranger-cd: {{{
function ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

# function ranger-shell {
#     ranger && exit
# }

[[ -n $RANGERSHELL ]] && unset RANGERSHELL && ranger && exit
[[ -n $RANGERCD ]] && unset RANGERCD && ranger-cd && exit

#}}}
# nnn: cd on quit: {{{
f()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}
# nnn: cd on quit: }}}
# ring: {{{
ring() {
    ## Works even if terminal is closed, unlike the other two
    local dtime=$1; shift
    local time
    if [[ $dtime =~ ":" ]]; then
        time=$dtime
    else
        time=$(pdd --add $(toseconds $dtime) | head -n 1)
    fi
    # echo $time
    time=$(echo $time | tr -d ':') 
    time=$time[1,4] ## Move to 'at' format
    # echo $time
    echo "notify-send --urgency=critical 'Reminder' '$@'" | at $time
}
# }}}
# Dotfile management: {{{
## Functions are better for pipes
export DOTDIR=$HOME/.dots
function dot()  {/usr/bin/git --git-dir=$DOTDIR --work-tree=$HOME "$@"}
function dots() {/usr/bin/git --git-dir=$DOTDIR --work-tree=$HOME status "$@"}
function dotc() {/usr/bin/git --git-dir=$DOTDIR --work-tree=$HOME commit --verbose "$@"}
function dota() {/usr/bin/git --git-dir=$DOTDIR --work-tree=$HOME add "$@"}
function dotu() {/usr/bin/git --git-dir=$DOTDIR --work-tree=$HOME add --update "$@"}
function dotd() {/usr/bin/git --git-dir=$DOTDIR --work-tree=$HOME diff "$@"}
function dotr() {/usr/bin/git --git-dir=$DOTDIR --work-tree=$HOME rm "$@"}

function dotf(){
    ## setting the env vars helps vim-fugitive know what's going on
    [ -n "$@" ] && QUERY="-q $@"
    /usr/bin/git --git-dir=$DOTDIR --work-tree=$HOME ls-tree --full-tree -r HEAD | awk '{print $NF}' | sed "s@^@$HOME/@" | fzf --preview="scope.sh {q} {}" -1 -0 -e $QUERY | GIT_DIR=$DOTDIR GIT_WORK_TREE=$HOME filer
}

function dotaf(){
    files=$(/usr/bin/git --git-dir=$DOTDIR --work-tree=$HOME diff --name-only | sed "s@^@$HOME/@" | fzf -m --preview="/usr/bin/git --git-dir=$DOTDIR --work-tree=$HOME diff --color {}" )
    [ -n "$files" ] && echo "$files" | xargs /usr/bin/git --git-dir=$DOTDIR --work-tree=$HOME add 
}

## FZF
function dotlog(){
    _gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
    _viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git --git-dir=$DOTDIR --work-tree=$HOME show --color=always % | less '"
    dot log --color=always --format="%C(auto)%h%d %s %C(cyan)%C(bold)%cr% C(auto)%an" "$@" |
        fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi --preview="$_viewGitLogLine" \
                --header "enter to view, ctrl-y to copy hash" \
                --bind "enter:execute:$_viewGitLogLine   | less -R" \
                --bind "ctrl-y:execute:$_gitLogLineToHash | xclip -i -selection clipboard"
}

## To use local dotfile directories, 
## DOTDIR=$HOME/.localdots dot
## An alias to make even that easy:
alias LD="DOTDIR=$HOME/.localdots"

# }}}
# peek: {{{
peek()
{
    ## An upgrade to filer
    ## Because I'm bored and sometimes have OCD

    urlregex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
    OPENER="xdg-open"
    DEBUG="OFF"

    POSITIONAL=()
    while [[ $# -gt 0 ]]
    do
        key="$1"
        case $key in
            -o|--opener)
                OPENER="$2"
                shift # past value
                shift # past value
                ;;
            -d|--debug)
                DEBUG="ON"
                shift # past value
                ;;
            *)    # unknown option
                POSITIONAL+=("$1") # save it in an array for later
                shift # past argument
                ;;
        esac
    done
    set -- "${POSITIONAL[@]}" # restore positional parameters


    if [[ -n "$@" ]]; then
        FILES="$@"
    else
        ## Space separated
        # read -r FILES

        ## Newline separated, becuase fzf pipes
        FILES=()
        while read -r line; do
            # echo "> $line"
            FILES+=( "$line" )
        done
    fi

    open()
    {
        nohup "$@" > /dev/null 2>&1 & disown
    }

    guiopen()
    {
        nohup "$OPENER" "$@" >/dev/null 2>&1 & disown
    }

    switch()
    {

        FILE="$@"
        FILEBASENAME=$(basename "$FILE")
        [[ "$FILEBASENAME" =~ "." ]] && EXT=${FILEBASENAME##*.} || EXT=""
        FILETYPE="$(file --mime-type "$FILE" | awk -F ': ' '{print $2}')"

        if [[ "$DEBUG" == "ON" ]]; then 
            echo "file=$FILE"
            echo "filebasename=$FILEBASENAME"
            echo "ext=$EXT"
            echo "c[0]=${FILEBASENAME:0:1}"
            echo "filetype=$FILETYPE"
            echo "------------------"
        fi

        if [[ "$FILETYPE" == *"text"* ]]; then
            $EDITOR "$FILE" && return 
        elif [[ "$FILE" =~ $urlregex ]]; then
            if [[ "$FILE" =~ "youtube" ]]; then
                open mpv "$FILE"
            else
                guiopen "$FILE"
            fi
        fi

        case "$FILETYPE" in 
            "inode/directory"         ) builtin cd "$FILE"            ; return ;;
            "inode/symlink"           ) switch "$(readlink -f $FILE)" ; return ;;
            "inode/x-empty"           ) $EDITOR "$FILE"               ; return ;;
            "application/octet-stream") dex -e "$FILE"                ; return ;;
            "text/html"               ) guiopen "$FILE"               ; return ;;
            "application/pdf"         ) guiopen "$FILE"               ; return ;;
            "application/json"        ) $EDITOR "$FILE"               ; return ;;
            "text/plain"              ) $EDITOR "$FILE"               ; return ;;
            *                         ) ;;
        esac


    }

    for FILE in "${FILES[@]}"; do
        switch "$FILE"
    done
}
# peek: }}}
# }}}

# Bell Hook: {{{
## this may already be in your ~/.zshrc
autoload -Uz add-zsh-hook
# duration in seconds after which a bell should be sent
typeset -i LONGRUNTIME=30
# function to save time at which a command was started
save_starttime () {
  starttime=$SECONDS
}
# function to print \a if the command took longer than LONGRUNTIME
set_longrunning_alert () {
  if ((LONGRUNTIME > 0 && SECONDS - starttime >= LONGRUNTIME)); then
    print "\a"
  fi
}
# run save_starttime before a command is executed
add-zsh-hook preexec save_starttime
# run set_longrunning_alert after a command finishes (before the prompt)
add-zsh-hook precmd set_longrunning_alert
# }}}

## SSH TMUX REFRESH ENV: {{{
# updates DISPLAY env in outdated tmux sessions
function tmux_update_display(){
    if [ -n "$TMUX" ]; then
        if [[ $(tmux show-env | grep "^DISPLAY" | sed 's/DISPLAY=//') != $DISPLAY ]]; then
            # echo "DISPLAY OUTDATED!"
            export $(tmux show-environment | grep "^DISPLAY")
        fi
    fi
}
add-zsh-hook preexec tmux_update_display

## SSH TMUX REFRESH ENV: }}}

function vimfu()
{
    file=$(findup.py "$@")
    if [ -n "$file" ]; then
        $EDITOR "$file"
    fi
}

## Fuzzy pass browser
fpass() {
    local DIR=${PWD}
    cd ~/.password-store
    fzf --bind="enter:execute@dex -p {}@,ctrl-d:execute@rm {}@,ctrl-b:execute@echo {} | sed 's/.gpg//' | xargs pass | grep url | awk '{print \$2}' | xargs firefox --new-tab@,ctrl-o:execute@echo {} | sed 's/.gpg//' | xargs pass edit@" 
    cd "$DIR"
}

alias F="sudo -E nnn -dH" # sudo file browser

