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
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk


### Functions to make zinit configuration less verbose
zpt() { zinit ice wait"${1}" lucid               "${@:2}"; } # Turbo
zpi() { zinit ice lucid                            "${@}"; } # Regular Ice
zp()  { [ -z $2 ] && zinit light $@ || zinit $@; } # zinit

# Some inspiration from https://github.com/crivotz/dot_files/blob/master/linux/zplugin/zshrc
# autoload -Uz compinit; compinit

zinit snippet OMZL::directories.zsh 
zinit snippet OMZL::termsupport.zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZP::git

# Other OMZ options
# zinit wait lucid for \ OMZL::git.zsh \ OMZL::clipboard.zsh \ OMZL::grep.zsh \ OMZL::history.zsh \ OMZL::spectrum.zsh \ OMZP::git \ OMZP::fzf 

zpt 0b blockf
zp zsh-users/zsh-completions

zinit ice from"gh-r" as"command"
zinit light junegunn/fzf

zinit ice lucid wait'0c' as"command" id-as"junegunn/fzf-tmux" pick"bin/fzf-tmux"
zinit light junegunn/fzf

zinit ice lucid wait'0c' multisrc"shell/{completion,key-bindings}.zsh" id-as"junegunn/fzf_completions" pick"/dev/null"
zinit light junegunn/fzf

zp Aloxaf/fzf-tab

if [ $HOST != "IBT918" ]; then
    # RIPGREP:{{{
    zinit ice from"gh-r" as"program" mv"ripgrep* -> ripgrep" pick"ripgrep/rg"
    zinit light BurntSushi/ripgrep
    # }}}
    # NEOVIM: {{{
    zinit ice from"gh-r" as"program" bpick"*appimage*" ver"nightly" mv"nvim* -> nvim" pick"nvim"
    zinit light neovim/neovim
    # }}}
    # RANGER:{{{
    zinit ice depth'1' as"program" pick"ranger.py"
    zinit light ranger/ranger
    # }}}
    # FD: {{{
    zinit ice as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
    zinit light sharkdp/fd
    # }}}
    # GH-CLI: {{{
    zinit ice lucid wait"0" as"program" from"gh-r" pick"usr/bin/gh"
    zinit light "cli/cli"
    # }}}
    # TMUX: {{{
    zinit ice from"gh-r" as"program" mv"tmux* -> tmux" pick"tmux" atload"alias tmux=tmux"
    zinit light tmux/tmux
    # }}}
    # NNN: {{{
    zinit ice from"gh-r" as"program" mv"nnn* -> nnn" bpick"nnn-static*"
    zinit light jarun/nnn
    # }}}
# DISKUS: {{{
zinit ice as"command" from"gh-r" mv"diskus* -> diskus" pick"diskus/diskus"
zinit light sharkdp/diskus
# }}}
fi

zinit ice as"command" from"gh" pick"bin/git-fuzzy"
zinit light bigH/git-fuzzy

zpt 0a lucid atload"_zsh_autosuggest_start"
zp zsh-users/zsh-autosuggestions

## Remove the the next line if compaudit complains of insecurity 
zpt 0b atload'zpcompinit;zpcdreplay'
zp zdharma/fast-syntax-highlighting

zinit for \
    light-mode pick"async.zsh" src"pure.zsh" \
    sindresorhus/pure

# Colors {{{
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
# bindkey -v                                                       # vim mode in shell 
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

# export NNN_FIFO=/tmp/nnn.fifo 
export NNN_OPTS="exaAu"
export NNN_COLORS="2136" ## Different colors for contexts 
export NNN_PLUG="g:getplugs;c:fuznavconf;f:fuznav;d:fuznavdir;i:imgview;d:diffs;v:preview-tui-ext"
export LC_COLLATE="C" ## dot files clumped together

## Exports: }}}

command -v nvim >/dev/null && export EDITOR='nvim' || export EDITOR='vim'
command -v nvim >/dev/null && alias vim="nvim" vimdiff="nvim -d" # Use neovim for vim if present.

#Alias {{{

alias i3c="dotf $HOME/.config/i3/config"
alias zc="dotf $HOME/.zshrc"
alias zcf="dotf $HOME/.zsh-fzf"
alias zcl="$EDITOR ~/.zsh-local"
alias nrc="dotf $HOME/.config/nvim/init.vim"
alias zsrc="source $HOME/.zshrc"

alias nn="note"
alias nd="notes -d $HOME/Dropbox/DND"
alias ndn="note -d $HOME/Dropbox/DND"
alias ns="notesearch"
alias fns="fnotesearch"
# alias nd="ls --group-directories-first $NOTES_DIR"
alias n="notes"

alias t="thesaurus"
alias gj="git-jump"
alias fu="findup.py"

alias -g ff="fuzscope | filer"
alias -g G='| grep -i'  ## Global alias
alias -g F='| fzf'  ## Global alias
alias -g X='>/dev/null 2>&1 & disown'
alias -g T='|& tee'
alias -g TL='|& tee out.log'
alias -g L='| less'

alias d='dirs -v | head -10'

alias ls='ls --color'
alias la='ls -la --color'
alias ll='ls -la --color --group-directories-first'

# Open modified files
# ACMR = Added || Copied || Modified || Renamed
alias vd="$EDITOR \$(git diff HEAD --name-only --diff-filter=ACMR)"
alias vds="$EDITOR \$(git diff --staged --name-only --diff-filter=ACMR)"
alias vdc="$EDITOR \$(git diff HEAD^ --name-only --diff-filter=ACMR)"
alias vdd="$EDITOR \$(git diff develop --name-only --diff-filter=ACMR)"


alias stj="ssh -qTfnN2 -D 8086 ibt014"

alias ra="ranger-cd"
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
function yp() {echo "$PWD/$1" | xclip -i -selection clipboard}
function yd() {echo "$PWD" | xclip -i -selection clipboard}
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
f ()
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
# filer:{{{
function filer(){
    # TODO: just move this to filer.sh and source the damn script for cd capacity?
    #           This won't allow using this in cd()?. 
    read KEY
    read FILE

    [ -z "$FILE" ] && FILE="$KEY"

    FILE=$(echo "$FILE" | cut -f1 -d"	")
    FILEBASENAME=${FILE##*/}
    [[ "$FILEBASENAME" =~ "." ]] && EXT=${FILEBASENAME##*.} || EXT=""
    FILETYPE="$(file --mime-type "$FILE" | awk '{print $NF}')"

    urlregex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'

    # echo "ext=$EXT"
    # echo "file=$FILE"
    # echo "filebasename=$FILEBASENAME"
    # echo "c[0]=${FILEBASENAME:0:1}"
    # echo "filetype=$FILETYPE"
    # echo "key=$KEY"
    # return

    ## TODO: Cleanup
    ## TODO: switch?
    
if [ -n "$FILE" ]; then
    if [[ -d "$FILE" ]]; then 
        builtin cd "$FILE" &> /dev/null
    elif [[ "$FILE" =~ $urlregex ]] && [[ "$FILE" =~ "youtube" ]]; then
        nohup mpv "$FILE" > /dev/null 2>&1 & disown
    elif [[ "$FILE" =~ $urlregex ]] && [[ "$FILE" =~ "xkcd" ]]; then 
        curl -sSL "$FILE" | hq img attr src | grep comics | sed 's/^/https:/' | xargs feh -Z
    elif [[ "$FILETYPE" =~ "octet-stream" ]]; then
        dex -e "$FILE"
    elif [[ "$KEY" == "ctrl-b" ]]; then
        termite -e ranger "$PWD/$FILE" 
    elif [[ "$KEY" == "ctrl-x" ]]; then
        xdg-open "$FILE" </dev/null >/dev/null 2>&1 & disown
    elif [[ "$EXT" == "pdf" ]]; then
        if [[ "$KEY" == "ctrl-p" ]]; then
            OPENER="polar-bookshelf"
        elif [[ "$KEY" == "ctrl-e" ]]; then 
            OPENER="evince"
        else
            OPENER="zathura"
        fi
        nohup "$OPENER" "$FILE" </dev/null >/dev/null 2>&1 & disown 
    elif [[ "$EXT" == "md" ]] && [[ "$KEY" == "ctrl-o" ]]; then
        xdg-open "$FILE"
    elif [[ "$EXT" == "csv" ]] || [[ "$KEY" == "ctrl-e" ]]; then
        "$EDITOR" "$FILE"
    elif [[ "$EXT" == "json" ]]; then
        "$EDITOR" "$FILE"
    elif [[ "$FILETYPE" == *"text"* ]] || [[ "$KEY" == "ctrl-e" ]]; then
        "$EDITOR" "$FILE" 
    elif [[ "$FILETYPE" == *"symlink"* ]] ; then
        "$EDITOR" $(readlink -f "$FILE")
    elif [[ "$FILETYPE" == *"application"* ]] || [[ "$KEY" == "ctrl-o" ]]; then
        xdg-open "$FILE" </dev/null >/dev/null 2>&1 & disown
    else
        xdg-open "$FILE" </dev/null >/dev/null 2>&1 & disown
    fi
fi

}
autoload -Uz filer
# filer:}}}

#}}}

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
# if [ -n "$TMUX" ]; then
#   function refresh {
#     # export $(tmux show-environment | grep "^SSH_AUTH_SOCK")
#     export $(tmux show-environment | grep "^DISPLAY")
#   }
# else
#   function refresh { }
# fi
# function preexec {
#     refresh
# }
## SSH TMUX REFRESH ENV: }}}


# ring() {
#   local time=$1; shift
#   sched "$time" "notify-send --urgency=critical 'Reminder' '$@'";
# }; compdef r=sched

# ringin() {
#     local dtime=$1; shift
#     local time=$(pdd --add $(toseconds $dtime) | head -n 1)
#     # ring "$time" "$@"
#     echo $time
# }

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

function vimfu()
{
    file=$(findup.py "$@")
    if [ -n "$file" ]; then
        $EDITOR "$file"
    fi
}

## Functions are better for pipes
function dot()  {/usr/bin/git --git-dir=$HOME/.dots --work-tree=$HOME "$@"}
function dots() {/usr/bin/git --git-dir=$HOME/.dots --work-tree=$HOME status "$@"}
function dotc() {/usr/bin/git --git-dir=$HOME/.dots --work-tree=$HOME commit --verbose "$@"}
function dota() {/usr/bin/git --git-dir=$HOME/.dots --work-tree=$HOME add "$@"}
function dotu() {/usr/bin/git --git-dir=$HOME/.dots --work-tree=$HOME add --update "$@"}
function dotd() {/usr/bin/git --git-dir=$HOME/.dots --work-tree=$HOME diff "$@"}
function dotr() {/usr/bin/git --git-dir=$HOME/.dots --work-tree=$HOME rm "$@"}

function dotf(){
    ## setting the env vars helps vim-fugitive know what's going on
    [ -n "$@" ] && QUERY="-q $@"
    /usr/bin/git --git-dir=$HOME/.dots --work-tree=$HOME ls-tree --full-tree -r HEAD | awk '{print $NF}' | sed "s@^@$HOME/@" | fzf --preview="scope.sh {q} {}" -1 -0 -e $QUERY | GIT_DIR=$HOME/.dots GIT_WORK_TREE=$HOME filer
}

function dotaf(){
    files=$(/usr/bin/git --git-dir=$HOME/.dots --work-tree=$HOME diff --name-only | sed "s@^@$HOME/@" | fzf -m --preview='/usr/bin/git --git-dir=$HOME/.dots --work-tree=$HOME diff --color {}' )
    [ -n "$files" ] && echo "$files" | xargs dota
}
