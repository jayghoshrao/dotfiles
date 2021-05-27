" vim: fdm=marker

" ███    ██  ███████   ██████   ██    ██  ██  ███    ███    
" ████   ██  ██       ██    ██  ██    ██  ██  ████  ████    
" ██ ██  ██  █████    ██    ██  ██    ██  ██  ██ ████ ██    
" ██  ██ ██  ██       ██    ██   ██  ██   ██  ██  ██  ██    
" ██   ████  ███████   ██████     ████    ██  ██      ██    


" [TASK]: Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
" [TASK]: Make <space>f to universal find/locate?
" [TASK]: Check out https://github.com/gillescastel/latex-snippets
" [TASK]: latex \item indentation/syntax
" [TASK]: Better compatibility with remote servers: Simpler vimrc
" [TASK]: https://github.com/vim-scripts/argtextobj.vim
" [TASK]: https://github.com/bkad/CamelCaseMotion
" [DONE]: Check out omnipytent
" [TASK]: Task tag highlights with Goyo enter and leave
" [TASK]: Plug 'voldikss/vim-floaterm'
" [TASK]: https://github.com/junegunn/vim-peekaboo

" https://github.com/stefandtw/quickfix-reflector.vim

let g:polyglot_disabled = ['markdown']


" Plugins :{{{
set nocompatible              " be iMproved, required
filetype off                  " required

" With a map leader it's possible to do extra key combinations
" " like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","
" nnoremap ; :
" vnoremap ; :

" set the runtime path to include Vundle and initialize
" set rtp+=~/.config/nvim/bundle/Vundle.vim
"call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/.config/nvim/bundle')
call plug#begin('~/.config/nvim/bundle')

" Declarations: {{{

" let Vundle manage Vundle, required
" Plug 'VundleVim/Vundle.vim'

" Plug 'tenfyzhong/CompleteParameter.vim'                       " GOOD STUFF, but config clash with tmux needs to be fixed. 
Plug 'sheerun/vim-polyglot'
" Plug 'psliwka/vim-smoothie'                                     " Smooth Scrolling 
Plug 'jremmen/vim-ripgrep'
Plug 'rbong/vim-crystalline'

" Plug 'brennier/quicktex'
" Plug 'dhruvasagar/vim-table-mode'
" Plug 'godlygeek/tabular'
" Plug 'plasticboy/vim-markdown'
" Plug 'norcalli/nvim-colorizer.lua'
" Plug 'vim-pandoc/vim-pandoc-syntax'                           ## TOO SLOW
" Plug 'zenbro/mirror.vim'
" Plug 'kien/ctrlp.vim'                                         " File Access
" Plug 'wellle/targets.vim'
"
Plug 'ekalinin/Dockerfile.vim'

Plug 'lervag/vimtex'
Plug 'lambdalisue/suda.vim'
Plug 'Valloric/ListToggle' 
Plug 'idanarye/vim-omnipytent'                                " build system
Plug 'arcticicestudio/nord-vim'                               " theme

Plug 'tpope/vim-commentary'                                   " comments and stuff
Plug 'tpope/vim-surround'                                     " brackets and stuff
Plug 'tpope/vim-unimpaired'                                   " easy maps with []
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-obsession'                                    " Sessions in vim (best paired with tmux-continuum)

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'                                      " Centered Wrapping
Plug 'junegunn/limelight.vim'                                 " Highlight current Paragraph, dim everything else

Plug 'Konfekt/FastFold'
Plug 'Raimondi/delimitMate'                                 
" Plug 'ludovicchabant/vim-gutentags'
Plug 'mcchrish/nnn.vim'
Plug 'michaeljsmith/vim-indent-object'
" Plug 'nathanaelkane/vim-indent-guides'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'skywind3000/asyncrun.vim'
Plug 'tommcdo/vim-lion'                                       " Alignment with characters (Ex: =)
Plug 'universal-ctags/ctags'
Plug 'vim-pandoc/vim-pandoc'

Plug 'mboughaba/i3config.vim'

" }}}

"Delimitmate: {{{
let delimitMate_expand_cr = 1
" }}}
"Tags: {{{

let g:gutentags_cache_dir='~/.cache/gutentags_cache_dir'
let g:gutentags_ctags_exclude=['*.md','*.html', '*/doc/*']
let g:gutentags_ctags_extra_args = ['--fields=+S']
if executable('rg') | let g:gutentags_file_list_command = 'rg --files' | endif

"}}}
"Goyo: {{{

noremap <leader>g :Goyo<CR>

let g:goyo_width = 100
let g:goyo_height = '90%'

function! s:goyo_enter()
    set noshowmode
    set noshowcmd
    " set scrolloff=999
    set wrap
    set linebreak
    set nolist  " list disables linebreak
    set formatoptions-=t
    " Limelight
endfunction

function! s:goyo_leave()
    set showmode
    set showcmd
    " set scrolloff=2
    set nolinebreak
    set list  " list disables linebreak
    set formatoptions+=t
    " Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

"}}}
""Airline: {{{

"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"let g:airline_powerline_fonts = 1
"let g:Powerline_symbols = 'unicode'
"let g:airline#extensions#tabline#enabled = 1

""}}}
" " mkdx-settings {{{

" Plug 'SidOfc/mkdx'
" let g:mkdx#settings = {
"       \ 'image_extension_pattern': 'a\?png\|jpe\?g\|gif',
"       \ 'restore_visual':          1,
"       \ 'enter':                   { 'enable': 1, 'malformed': 1, 'o': 1,
"       \                              'shifto': 1, 'shift': 0 },
"       \ 'map':                     { 'prefix': '<space>', 'enable': 1 },
"       \ 'tokens':                  { 'enter': ['-', '*', '>'],
"       \                              'bold': '**', 'italic': '*', 'strike': '',
"       \                              'list': '-', 'fence': '',
"       \                              'header': '#' },
"       \ 'checkbox':                { 'toggles': ['TASK', 'ONGO', 'DONE', 'NEXT', 'WAIT', 'PASS', 'FAIL', 'DROP', 'X', ' '],
"       \                              'update_tree': 2,
"       \                              'initial_state': 'TASK' },
"       \ 'toc':                     { 'text': "TOC", 'list_token': '-',
"       \                              'update_on_write': 0,
"       \                              'position': 0,
"       \                              'details': {
"       \                                 'enable': 0,
"       \                                 'summary': 'Click to expand {{toc.text}}',
"       \                                 'nesting_level': -1,
"       \                                 'child_count': 5,
"       \                                 'child_summary': 'show {{count}} items'
"       \                              }
"       \                            },
"       \ 'table':                   { 'divider': '|',
"       \                              'header_divider': '-',
"       \                              'align': {
"       \                                 'left':    [],
"       \                                 'center':  [],
"       \                                 'right':   [],
"       \                                 'default': 'left'
"       \                              }
"       \                            },
"       \ 'links':                   { 'external': {
"       \                                 'enable': 0, 'timeout': 3, 'host': '', 'relative': 1,
"       \                                 'user_agent':  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/9001.0.0000.000 vim-mkdx/1.9.1'
"       \                              },
"       \                              'fragment': {
"       \                                 'jumplist': 1,
"       \                                 'complete': 1
"       \                              }
"       \                            },
"       \ 'highlight':               { 'enable': 0 },
"       \ 'auto_update':             { 'enable': 0 }
"     \ }
" " }}}
"Lion: {{{
" let g:lion_squeeze_spaces = 1
"}}}
""Ultisnips: {{{

"" Track the engine.
"Plug 'SirVer/ultisnips'

"" Snippets are separated from the engine. Add this if you want them:
"Plug 'honza/vim-snippets'

"" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.

"let g:UltiSnipsExpandTrigger="<c-a>"
"" let g:UltiSnipsJumpForwardTrigger="<c-b>"
"" let g:UltiSnipsJumpBackwardTrigger="<c-z>"

"" let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<tab>"
"let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"let g:UltiSnipsEditSplit="vertical"

"let g:UltiSnipsSnippetDirectories = [ "bundle/vim-snippets/UltiSnips", "UltiSnips" ]

""}}}
" VimWiki:{{{
    Plug 'vimwiki/vimwiki'

    let g:vimwiki_list = [{'path': '~/Dropbox/Notes/',
                          \ 'syntax': 'markdown', 'ext': '.md'}, 
                        \ {'path': '~/Dropbox/DND/', 
                        \ 'syntax': 'markdown', 'ext': '.md'}, 
                        \ {'path': '~/Dropbox/Vault/', 
                        \ 'syntax': 'markdown', 'ext': '.md'} ]

    " let g:vimwiki_folding='syntax'
    let g:vimwiki_folding='expr'
    let g:vimwiki_table_mappings=0
    au FileType vimwiki set filetype=vimwiki.markdown.pandoc.tex
" }}}

" function! StatusLine(...)
"   return '%#Crystalline# %f%h%w%m%r %#CrystallineFill#'
"         \ . '%=%#Crystalline# %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
" endfunction
" let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_enable_sep = 1
let g:crystalline_theme = 'nord'
set tabline=%!crystalline#bufferline()
set showtabline=2
" set laststatus=2

" All of your Plugins must be added before the following line
" call vundle#end()            " required
call plug#end()            " required
" filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" filetype plugin on

" }}}

"Set Options: {{{

"set t_Co=256
let g:nord_italic=1
let g:nord_italic_comments=1
let g:nord_underline=1
" let g:nord_comment_brightness=5

augroup nord-overrides
    autocmd!
    autocmd ColorScheme nord highlight Folded cterm=italic ctermbg=0 ctermfg=12 guibg=#3B4252 guifg=#b5b5b5
augroup END

colorscheme nord
" colorscheme Tomorrow-Night

" set hidden
" set cmdheight=2

"tmux colors
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

set nohidden
set relativenumber
set mouse=a             "Copy selected text with mouse to system clipboard
set undofile            " Persistent undos through file closes 
set nojoinspaces
set cursorline
set termguicolors
set wildignore+=*.o,*.tar.gz,*.pdf,*.log,*.dat,*.mod
set wildignore+=*/.git/*,*/tmp/*,*.swp,*/doc/*
set wildignore+=*.html,*.svg
set shortmess+=c          " don't give |ins-completion-menu| messages.
set incsearch             " Search as you type
set ignorecase            " self-explanatory
set expandtab
set smartcase             " case sensitive when using upper-case in search term
set smarttab              " tab length decided by shiftwidth if on, tabstop if off
set shiftwidth=4
set tabstop=4
set softtabstop=4
set scrolloff=2           " show x lines of context after/before cursor
set modeline
set wildmode=longest,list
set number                " show line number
set ruler                 " show cursor position in status bar
set nohlsearch            " remove highlights after search complete
set ai                    " AutoIndent
set si                    " SmartIndent
set wrap                  " WrapLines
set showmatch             " show matching bracket briefly
set matchtime=2
set splitright            " vsplit defaults right
set splitbelow            " split defaults bottom
set wildmenu
set laststatus=0          " use 2 for airline, 0 otherwise
set inccommand=split
set clipboard=unnamedplus		"register = clipboard"
set completeopt=noinsert,menuone,noselect
set timeout timeoutlen=800 ttimeoutlen=10
set updatetime=300        " Smaller updatetime for CursorHold & CursorHoldI
set spelllang=en_gb
set conceallevel=2
set signcolumn=yes          " always show signcolumns: helps with linters for error signs >>
set shortmess+=c

" Search down into subfolders
" Provides tab-completion for all file related tasks
set path+=**

" Fixes common backspace problems
set backspace=indent,eol,start

hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=darkgrey
hi notesItalic term=italic gui=italic
hi TermCursor ctermfg=red guifg=red

"Fortran:{{{

let fortran_free_source            = 1
let fortran_do_enddo               = 1
let fortran_have_tabs              = 1
let fortran_more_precise           = 1
" let fortran_dialect                = 'f90'
let fortran_fold                   = 1
let fortran_fold_conditionals      = 1
let fortran_fold_multilinecomments = 1
" hi link fortranTab NONE

"}}}

syntax on                 "neovim default on

"}}}

"Mappings: {{{

map j gj
map k gk

" Required for vim-smoothie
" map J <C-d> 
" map K <C-U>

noremap J <C-d>
noremap K <C-U>
noremap H g^
noremap L g$

nnoremap U <C-r>

" xnoremap < <gv
" xnoremap > >gv

"=== SPLIT FOCUS ===

"noremap <A-h> <C-w>h
"noremap <A-j> <C-w>j
"noremap <A-k> <C-w>k
"noremap <A-l> <C-w>l

noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

"== Fast saving
nmap <leader>w :w!<cr>
nmap <leader>q :q<cr>
nmap <leader>x :q!<cr>
nnoremap <C-s> :w!<cr>
inoremap <C-s> <Esc>:w!<cr>
nnoremap <C-q> :q<CR>
inoremap <C-q> <Esc>:q<CR>

" nnoremap <space>s :w!<cr>
" nnoremap <space>x :q<cr>

"===== Timestamp =====
nnoremap <F5> "=strftime("%Y-%m-%d %H:%M")<CR>
inoremap <F5> <C-R>=strftime("%Y-%m-%d %H:%M")<CR>

"====== HACKS =========
inoremap ;; <esc>A;<esc>
noremap <leader>jl <S-j>
nnoremap <leader>. :!!<CR>

command! MakeTags !ctags -R .

"===== ARROWS ========================
nnoremap <Left> :vertical resize +5<CR>
nnoremap <Right> :vertical resize -5<CR>

"" TextBubbling
" single line
nmap <C-Up> ddkP
nmap <C-Down> ddp
" multi line
vmap <C-Up> xkP`[V`]
vmap <C-Down> xp`[V`]

"======== DIR CMDS ==========
nnoremap <leader>ld :pwd<CR>
nnoremap <leader>d :lcd %:p:h<CR>
nnoremap <leader>lcd :lcd ~/


"=== edit vimrc/zshrc and load vimrc bindings
nnoremap <leader>ev :vsp ~/.config/nvim/init.vim<CR>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>sv :source ~/.config/nvim/init.vim<CR>

noremap <F2> :%s/\s*$//e<CR>

"======== BUFFERS ===========
nnoremap <space><space> :b#<CR>
nnoremap <BS> :b#<CR>
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nnoremap <space>d :bdelete!<CR>
nnoremap <space>l :Buffers<CR>

nnoremap <space>1 :b1<CR>
nnoremap <space>2 :b2<CR>
nnoremap <space>3 :b3<CR>
nnoremap <space>4 :b4<CR>
nnoremap <space>5 :b5<CR>
nnoremap <space>6 :b6<CR>
nnoremap <space>7 :b7<CR>
nnoremap <space>8 :b8<CR>
nnoremap <space>9 :b9<CR>
nnoremap <space>0 :b0<CR>

" New tab
nnoremap tn :tabnew<Space>

" Next/prev tab
nnoremap tk :tabnext<CR>
nnoremap tj :tabprev<CR>

" First/last tab
nnoremap th :tabfirst<CR>
nnoremap tl :tablast<CR>


"======== TERMINAL =============
au BufEnter,BufCreate,BufAdd,BufWinEnter,WinEnter * if &buftype == 'terminal' | :startinsert! | endif
autocmd BufWinEnter,WinEnter term://* startinsert!
tnoremap <leader><esc> <C-\><C-n>
tnoremap : <C-\><C-n>:
"tnoremap <space><space> <C-\><C-n>:b#<CR>

tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
" tnoremap <Tab> <C-\><C-n>:bnext<CR>
tnoremap <S-Tab> <C-\><C-n>:bprevious<CR>
tnoremap <leader>q :q<cr>

vmap <leader>, <Plug>(mkdx-tableize)

"}}}

"Remove Trailing Whitespace: {{{
autocmd FileType c,cpp,java,fortran,python,javascript autocmd BufWritePre <buffer> call StripTrailingWhitespace()
function! StripTrailingWhitespace()
    if !&binary && &filetype != 'diff'
        normal mz
        normal Hmy
        %s/\s\+$//e
        normal 'yz<CR>
        normal `z
    endif
endfunction
"}}}

" Terminal toggle:{{{
let g:term_buf = 0
function! Term_toggle()
    if g:term_buf == bufnr("")
        setlocal bufhidden=hide
        close
    else
        " botright vnew
        botright new
        try
            exec "buffer ".g:term_buf
        catch
            call termopen("zsh", {"detach": 0})
            file TERM
            let g:term_buf = bufnr("")
        endtry
        startinsert!
    endif
endfunction
noremap <leader>a :call Term_toggle()<cr>
tnoremap <leader>a <C-\><C-n>:call Term_toggle()<cr>

" " Terminal at the remote location. Useful with sshfs, and rcd script
" let g:term_buf_rem = 0
" function! Term_toggle_rem()
"     if g:term_buf_rem == bufnr("")
"         setlocal bufhidden=hide
"         close
"     else
"         " botright vnew
"         botright new
"         try
"             exec "buffer ".g:term_buf_rem
"         catch
"             call termopen("rcd", {"detach": 0})
"             file RTERM
"             let g:term_buf_rem = bufnr("")
"         endtry
"         startinsert!
"     endif
" endfunction
" noremap <leader>r :call Term_toggle_rem()<cr>
" tnoremap <leader>r <C-\><C-n>:call Term_toggle_rem()<cr>


"}}}

"Create Non Existent Directories:{{{
function! s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

"}}}

"netrw: {{{
let g:netrw_liststyle=3
let g:netrw_altv = 1
"}}}

" Autocmds: {{{
" Open read-only automatically if swapfile exists
autocmd SwapExists * let v:swapchoice = "o"  

" autocmd BufRead,BufNewFile *.in set filetype=conf
" autocmd Filetype tex set filetype=plaintex.tex
autocmd Filetype conf,cmake,xns set commentstring=#\ %s
autocmd Filetype tex set commentstring=%%\ %s

au BufNewFile,BufRead xns*in set filetype=xns

"o on line with comment won't generate a commented line
" autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"}}}

"Asyncrun functions:{{{
let g:asyncrun_rootmarks = ['.svn', '.git', '.root', '_darcs', 'build.xml']
let g:asyncrun_bell=20
let g:asyncrun_trim=1
let g:asyncrun_open=0
" let g:asyncrun_exit = "silent call system('echo -e \'\a\' &')"
"
" let g:asyncrun_exit = "silent call system('mpv --no-video ~/local/share/ding.mp3 &')"
" let g:asyncrun_exit = "silent call system('notify-send -t 2000 DONE! &')"

" C: {{{
function! s:AsyncRunC()
    let dir=expand('<amatch>:p:h') |
                \ if filereadable('build/Makefile') || filereadable('build/makefile') |
                \   execute 'AsyncRun make -C build' |
                \ endif
endfunction
" }}}

" Markdown: {{{
function! s:AsyncRunMD()
    let dir=expand('<amatch>:p:h') |
                \ if filereadable('Makefile') |
                \   execute 'AsyncRun make -j4 pdf' |
                \ elseif filereadable('../Makefile') |
                \   execute 'AsyncRun make -C .. -j4 pdf' |
                \ endif
endfunction
    
" }}}

" Quickfix: {{{
function! s:AsyncQuickFix()
    if g:asyncrun_status=='failure' |
                \   execute('call asyncrun#quickfix_toggle(10, 1)') |
                \ else |
                \   execute('call asyncrun#quickfix_toggle(10, 0)') |
                \ endif
    endfunction
" }}}

augroup asyncRunGroup
    " autocmd User AsyncRunStart call asyncrun#quickfix_toggle(20, 1)
	" autocmd BufWritePost *.c,*.cpp,*.h,*.hpp :call <SID>AsyncRunC()
	" autocmd BufWritePost *.md :call <SID>AsyncRunMD()
	" autocmd BufWritePost *.py :call <SID>AsyncRunPython()
	" autocmd FileType python :call <SID>AsyncRunPython()
	autocmd! User AsyncRunStop :call <SID>AsyncQuickFix()
augroup END

" let g:asyncrun_status = ''
" let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])

" " Asyncrun Airline: {{{
" " Define new accents
" function! AirlineThemePatch(palette)
"     " [ guifg, guibg, ctermfg, ctermbg, opts ].
"     " See "help attr-list" for valid values for the "opt" value.
"     " http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim
"     let a:palette.accents.running = [ '', '', '', '', '' ]
"     let a:palette.accents.success = [ '#00ff00', '' , 'green', '', '' ]
"     let a:palette.accents.failure = [ '#ff0000', '' , 'red', '', '' ]
" endfunction
" let g:airline_theme_patch_func = 'AirlineThemePatch'


" " Change color of the relevant section according to g:asyncrun_status, a global variable exposed by AsyncRun
" " 'running': default, 'success': green, 'failure': red
" let g:async_status_old = ''
" function! Get_asyncrun_running()

"     let async_status = g:asyncrun_status
"     if async_status != g:async_status_old

"         if async_status == 'running'
"             call airline#parts#define_accent('asyncrun_status', 'running')
"         elseif async_status == 'success'
"             call airline#parts#define_accent('asyncrun_status', 'success')
"         elseif async_status == 'failure'
"             call airline#parts#define_accent('asyncrun_status', 'failure')
"         endif

"         let g:airline_section_x = airline#section#create(['asyncrun_status'])
"         AirlineRefresh
"         let g:async_status_old = async_status

"     endif

"     return async_status

" endfunction

" call airline#parts#define_function('asyncrun_status', 'Get_asyncrun_running')
" let g:airline_section_x = airline#section#create(['asyncrun_status'])
" " }}}
    
"}}}

"FZF:{{{

nnoremap <silent> <space>o :Files<CR>
nnoremap <silent> <space>p :GFiles<CR>
nnoremap <silent> <space>h :History<CR>
nnoremap <silent> <space>/ :History/<CR>
nnoremap <silent> <space>; :History:<CR>
nnoremap <space>f :Find<space>
nnoremap <c-e> :FZFLines<CR>

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" nnoremap <silent> <space>g :exe 'GFiles ' . <SID>fzf_root()<CR>
" nnoremap <silent> <space>c :Commands<CR>


" fzf-setup: {{{

fun! s:fzf_root()
    let path = finddir(".git", expand("%:p:h").";")
    return fnamemodify(substitute(path, ".git", "", ""), ":p:h")
endfun

" This is the default extra key bindings
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" In Neovim, you can set up fzf window using a Vim command
" let g:fzf_layout = { 'window': 'enew' }
" let g:fzf_layout = { 'window': '-tabnew' }
" let g:fzf_layout = { 'window': '10split enew' }
" let g:fzf_layout = { 'window': '10new' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
            \ { 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'border':  ['fg', 'Ignore'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment'] }

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
            \| autocmd BufLeave <buffer> set laststatus=0 showmode ruler

" }}}
" fzf-let opts: {{{
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.

let g:fzf_history_dir = '~/.local/share/fzf-history'

" }}}
" fzf-notes: {{{
" command! -nargs=* Notes :FZF -e -1 -0 $NOTES_DIR
" command! -bang -nargs=? -complete=dir Notes call fzf#vim#files($NOTES_DIR, {'source': 'rg --files --iglob !*.png --iglob !*.pdf --iglob !*.jpg'}, <bang>0)
command! -bang -nargs=? -complete=dir Notes call fzf#vim#files($NOTES_DIR, {'source': 'rg --files --iglob !*.pdf'}, <bang>0)
command! -nargs=* Note :e $NOTES_DIR/<args>.md | :Goyo
nnoremap <space>n :Notes<CR>
" }}}
" fzf-find: {{{
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options

command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

command! -bang -nargs=* BL call fzf#vim#grep('mdl "'. expand('%:p') .'" '.shellescape(<q-args>), 1, <bang>0)
command! -bang -nargs=* FL call fzf#vim#grep('mdl "'. expand('%:p') .'" -f', 1, <bang>0)

nnoremap <space>j :FL<CR>
nnoremap <space>k :BL<CR>

" }}}
""FZFLine:{{{
function! s:line_handler(l)
  let keys = split(a:l, ':\t')
  exec 'buf' keys[0]
  exec keys[1]
  normal! ^zz
endfunction

function! s:buffer_lines()
  let res = []
  for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
    call extend(res, map(getbufline(b,0,"$"), 'b . ":\t" . (v:key + 1) . ":\t" . v:val '))
  endfor
  return res
endfunction

command! FZFLines call fzf#run({
\   'source':  <sid>buffer_lines(),
\   'sink':    function('<sid>line_handler'),
\   'options': '--extended --nth=3..',
\   'down':    '40%'})
" }}}

command! -bang -nargs=? -complete=dir Fopen call fzf#vim#files($HOME, {'source': 'fd . ~'}, <bang>0)
" command! -bang -nargs=? -complete=dir Fopen call fzf#vim#files(~, {'source': 'fd . ~'}, <bang>0)

"}}}

"Pandoc:{{{
" autocmd BufRead,BufNewFile *.md set commentstring=<!--%s-->

let g:pandoc#syntax#conceal#use = 1
let g:pandoc#syntax#style#use_definition_lists = 0
let g:pandoc#syntax#conceal#urls = 1
let g:pandoc#formatting#mode = "sA"
let g:pandoc#formatting#smart_autoformat_on_cursormoved = 1
let g:pandoc#command#use_message_buffers=1
let g:pandoc#folding#level = 1
" let g:pandoc#folding#mode = "relative"
let g:pandoc#folding#fold_vim_markers = 1
let g:pandoc#folding#vim_markers_in_comments_only = 1
" let g:pandoc#after#modules#enabled = ["nrrwrgn", "tablemode"]
" let g:pandoc#completion#bib#mode = 'citeproc'
" let g:pandoc#biblio#bibs = ["bib", "../bib/library.bib"]

let g:pandoc#spell#enabled = 0
let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
" let g:pandoc#command#autoexec_command = "Pandoc! pdf"

augroup markdown
    " autocmd FileType markdown.pandoc.tex :call <SID>MDSettings()
    " autocmd FileType pandoc :call <SID>MDSettings()

    autocmd! FileType vimwiki
    autocmd FileType vimwiki :noremap <buffer> <Leader>v :! nohup okular "%" >/dev/null 2>&1 & disown<CR><CR>
    autocmd FileType vimwiki :noremap <buffer> <Leader>t :! nohup typora "%" >/dev/null 2>&1 & disown<CR><CR>
    autocmd FileType vimwiki :noremap <buffer> <Leader>z :! nohup zathura '%<.pdf' 2>&1 >/dev/null & disown<CR><CR>
    autocmd FileType vimwiki :noremap <buffer> <Leader>h :! qutebrowser '%<.html' 2>&1 >/dev/null &<CR><CR>
    autocmd FileType vimwiki :noremap <buffer> <Leader>c :! pandoc --self-contained -t pdf '%' -o '%<.pdf'<CR>
    autocmd FileType markdown set filetype=vimwiki.markdown.pandoc.tex
    autocmd FileType vimwiki set syntax=vimwiki.markdown.pandoc.tex
    " autocmd Filetype vimwiki set commentstring=<!--%s-->
    " autocmd BufRead,BufNewFile *.md set commentstring=<!--%s-->

    " adjust syntax highlighting for LaTeX parts
    "   inline formulas:
    " syntax region Statement oneline matchgroup=Delimiter start="\$" end="\$"
    " "   environments:
    " syntax region Statement matchgroup=Delimiter start="\\begin{.*}" end="\\end{.*}" contains=Statement
    " "   commands:
    " syntax region Statement matchgroup=Delimiter start="{" end="}" contains=Statement
augroup END


" }}}

"Others:{{{

if filereadable($HOME . "/.vimrc_local")
    source ~/.vimrc_local
endif

command! -bang -nargs=* Mir :!mir <args>

let $PATH .= ':/home/jayghoshter/bin'
nnoremap <space>ar :AsyncRun compx rwth clean mpid<space>
nnoremap <space>aj :AsyncRun compx jur clean mpi<space>

"}}}

" TMUX: {{{
if exists('$TMUX')
  function! TmuxOrSplitSwitch(wincmd, tmuxdir)
    let previous_winnr = winnr()
    silent! execute "wincmd " . a:wincmd
    if previous_winnr == winnr()
      call system("tmux select-pane -" . a:tmuxdir)
      redraw!
    endif
  endfunction

  let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
  let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
  let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te

  nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
  nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
  nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
  nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
  map <C-h> <C-w>h
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l
endif
"  }}}

" CoC.nvim:{{{

" inoremap <silent><expr> <TAB>
"             \ pumvisible() ? "\<C-n>" :
"             \ <SID>check_back_space() ? "\<TAB>" :
"             \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
"     let col = col('.') - 1
"     return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-k> coc#refresh()

" " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" " Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Rename
nmap <leader>rn <Plug>(coc-rename)

" Use `[c` and `]c` to navigate diagnostics
"
nnoremap <silent> <space>c  :<C-u>CocDiagnostics<cr>
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
" nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> <leader>k :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for format selected region
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

" " Remap for do codeAction of current line
" nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
" nmap <leader>qf  <Plug>(coc-fix-current)
" nmap <leader>f  <Plug>(coc-fix-current)

" " Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" nmap <silent> <TAB> <Plug>(coc-range-select)
" xmap <silent> <TAB> <Plug>(coc-range-select)
" xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
" command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
" command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
" nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
" nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>'  :<C-u>CocList outline<cr>
" Search workspace symbols
" nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
" nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
" nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
" nnoremap <silent> <space>m  :<C-u>CocListResume<CR>

" }}}

" " Spotify Play: {{{
" " Given a spotify URI on a line, play it using splay
"     noremap <leader>m yiW:w !splay <C-r>"<CR><CR>
"     vnoremap <leader>m y:w !splay <C-r>"<CR><CR>
" " }}}

"Autocomplete: {{{
inoremap <silent><expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr><s-tab> pumvisible() ? "\<C-p>" : "\<TAB>"


" If you prefer the Omni-Completion tip window to close when a selection is
" " made, these lines close it on movement in insert mode or when leaving
" " insert mode
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

"}}}


" Nord:{{{

let s:nord0_gui = "#2E3440"
let s:nord1_gui = "#3B4252"
let s:nord2_gui = "#434C5E"
let s:nord3_gui = "#4C566A"
let s:nord3_gui_bright = "#616E88"
let s:nord4_gui = "#D8DEE9"
let s:nord5_gui = "#E5E9F0"
let s:nord6_gui = "#ECEFF4"
let s:nord7_gui = "#8FBCBB"
let s:nord8_gui = "#88C0D0"
let s:nord9_gui = "#81A1C1"
let s:nord10_gui = "#5E81AC"
let s:nord11_gui = "#BF616A"
let s:nord12_gui = "#D08770"
let s:nord13_gui = "#EBCB8B"
let s:nord14_gui = "#A3BE8C"
let s:nord15_gui = "#B48EAD"

let s:nord1_term = "0"
let s:nord3_term = "8"
let s:nord5_term = "7"
let s:nord6_term = "15"
let s:nord7_term = "14"
let s:nord8_term = "6"
let s:nord9_term = "4"
let s:nord10_term = "12"
let s:nord11_term = "1"
let s:nord12_term = "11"
let s:nord13_term = "3"
let s:nord14_term = "2"
let s:nord15_term = "5"

function! s:hi(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  if a:guifg != ""
    exec "hi " . a:group . " guifg=" . a:guifg
  endif
  if a:guibg != ""
    exec "hi " . a:group . " guibg=" . a:guibg
  endif
  if a:ctermfg != ""
    exec "hi " . a:group . " ctermfg=" . a:ctermfg
  endif
  if a:ctermbg != ""
    exec "hi " . a:group . " ctermbg=" . a:ctermbg
  endif
  if a:attr != ""
    exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a.attr
  endif
  if a:guisp != ""
    exec "hi " . a:group . " guisp=" . a:guisp
  endif
endfunction

" }}}

" Task Tag Highlights:{{{
call s:hi("MyError", s:nord0_gui, s:nord11_gui, "", s:nord11_term, "", "")
call s:hi("MySuccess", s:nord0_gui, s:nord14_gui, "", s:nord14_term, "", "")
call s:hi("MyOngoing", s:nord0_gui, s:nord7_gui, "", s:nord7_term, "", "")
call s:hi("MyTask", s:nord0_gui, s:nord13_gui, "", s:nord13_term, "", "")
call s:hi("MyNote", s:nord0_gui, s:nord10_gui, "", s:nord10_term, "", "")
call s:hi("MyWait", s:nord0_gui, s:nord15_gui, "", s:nord15_term, "", "")
call s:hi("MyDrop", s:nord0_gui, s:nord6_gui, "", s:nord6_term, "", "")
call s:hi("MyNext", s:nord0_gui, s:nord12_gui, "", s:nord12_term, "", "")
call s:hi("MyPush", s:nord0_gui, s:nord12_gui, "", s:nord12_term, "", "")
call s:hi("MyProject", s:nord0_gui, s:nord5_gui, "", s:nord5_term, "", "")


augroup HiglightTODO
    autocmd!
    autocmd BufEnter * :silent! call matchadd('MySuccess', '\[PASS\]', -1)
    autocmd BufEnter * :silent! call matchadd('MyProject', '\[PROJ:[^]]*\]', -1)
    autocmd BufEnter * :silent! call matchadd('MyProject', '\[PROJ]', -1)
    autocmd BufEnter * :silent! call matchadd('MySuccess', '\[DONE\]', -1)
    autocmd BufEnter * :silent! call matchadd('MyOngoing', '\[ONGO\]', -1)
    autocmd BufEnter * :silent! call matchadd('MyOngoing', '\[PART\]', -1)
    autocmd BufEnter * :silent! call matchadd('MyError', '\[PROB\]', -1)
    autocmd BufEnter * :silent! call matchadd('MyError', '\[FAIL\]', -1)
    autocmd BufEnter * :silent! call matchadd('MyTask', '\[WORK\]', -1)
    autocmd BufEnter * :silent! call matchadd('MyTask', '\[TASK\]', -1)
    autocmd BufEnter * :silent! call matchadd('MyTask', '\[DCHK\]', -1)
    autocmd BufEnter * :silent! call matchadd('MyTask', '\[REVW\]', -1)
    autocmd BufEnter * :silent! call matchadd('MyNote', '\[NOTE\]', -1)
    autocmd BufEnter * :silent! call matchadd('MyNote', '\[MEET\]', -1)
    autocmd BufEnter * :silent! call matchadd('MyWait', '\[WAIT\]', -1)
    autocmd BufEnter * :silent! call matchadd('MyDrop', '\[DROP\]', -1)
    autocmd BufEnter * :silent! call matchadd('MyNext', '\[NEXT\]', -1)
    autocmd BufEnter * :silent! call matchadd('MyPush', '\[PUSH\]', -1)
augroup END

augroup HighlightDND
    autocmd BufEnter * :silent! call matchadd('MyOngoing', '@npc', -1)
    autocmd BufEnter * :silent! call matchadd('MyWait', '@loc', -1)
    autocmd BufEnter * :silent! call matchadd('MySuccess', '@DC[0-9][0-9]', -1)
    autocmd BufEnter * :silent! call matchadd('MyProject', '@scene', -1)
    autocmd BufEnter * :silent! call matchadd('MyNext', '@trial', -1)
    autocmd BufEnter * :silent! call matchadd('MyError', '@combat', -1)
    autocmd BufEnter * :silent! call matchadd('MyTask', '@task', -1)
augroup  END

" More keywords: HALT, HOLD, STOP, REVW, DCHK
" TODO: Save cursor positions
" TODO: If exists but different, change to current, elseif same, toggle, else
" create


function! Tasker(tag)
    let l:line = getline('.')
    let l:lineno = line('.')
    if match(line, '- \['.a:tag.'\]')>-1 
        call setline(lineno, substitute(line, ' \['.a:tag.'\]', '', '') )
    elseif match(line, '\['.a:tag.'\]')>-1
        call setline(lineno, substitute(line, '\['.a:tag.'\] ', '', '') )
    elseif match(line, '- \[....\]')>-1
        call setline(lineno, substitute(line, '\[....\]', '\['.a:tag.']', '') )
    elseif match(line, '\[....\]')>-1
        call setline(lineno, substitute(line, '\[....\]', '\['.a:tag.']', '') )
    elseif match(line, '^\s*-')>-1
        call setline(lineno, substitute(line, '-', '- \['.a:tag.'\]', ''))
    else
        call setline(lineno, substitute(line, '^', '\['.a:tag.'\] ', ''))
    endif
endfunction

" nnoremap ;e :call Tasker(' ')<CR>0f[ 
nnoremap ;x :call Tasker('NEXT')<CR> 
nnoremap ;t :call Tasker('TASK')<CR>
nnoremap ;o :call Tasker('ONGO')<CR>
nnoremap ;d :call Tasker('DONE')<CR>
nnoremap ;r :call Tasker('DROP')<CR>
nnoremap ;p :call Tasker('PROB')<CR>
nnoremap ;f :call Tasker('FAIL')<CR>
nnoremap ;n :call Tasker('NOTE')<CR>
nnoremap ;w :call Tasker('WAIT')<CR>
nnoremap ;u :call Tasker('PUSH')<CR>
nnoremap ;m :call Tasker('MEET')<CR>

" vnoremap ;e :call Tasker(' ')<CR>0f[ 
" vnoremap ;x :call Tasker('X')<CR> 
vnoremap ;x :call Tasker('NEXT')<CR> 
vnoremap ;t :call Tasker('TASK')<CR>
vnoremap ;o :call Tasker('ONGO')<CR>
vnoremap ;d :call Tasker('DONE')<CR>
vnoremap ;r :call Tasker('DROP')<CR>
vnoremap ;p :call Tasker('PROB')<CR>
vnoremap ;f :call Tasker('FAIL')<CR>
vnoremap ;n :call Tasker('NOTE')<CR>
vnoremap ;w :call Tasker('WAIT')<CR>
vnoremap ;u :call Tasker('PUSH')<CR>
vnoremap ;m :call Tasker('MEET')<CR>

" }}}

let g:omnipytent_filePrefix = '.jrao' " Replace with your own (user)name
let g:omnipytent_defaultPythonVersion = 3 " Or 2, if you want to use Python 2

let g:lt_location_list_toggle_map = '<space>w'
let g:lt_quickfix_list_toggle_map = '<space>q'
let g:lt_height = 10

" nnoremap <space>q :call asyncrun#quickfix_toggle(20)<cr>
" nnoremap <space>l :lopen<CR>

" Fugitive maps
nnoremap <space>gd :Gvdiffsplit<CR>

" TeX 
let g:tex_flavor = "latex"
let g:tex_indent_brace = 1 
let g:tex_indent_items = 1
let g:tex_items = 1
let g:tex_itemize_env = 1 
" let g:tex_noindent_env 
" let g:tex_indent_and: Whether to align the line with the first 
"

highlight Conceal guifg=#81A1C1 guibg=#2E3440

let g:vimtex_fold_enabled = 1

let g:vimtex_log_ignore = [ 'Underfull', 'contains only floats' ]
let g:vimtex_quickfix_ignore_filters = [ 'Underfull', 'contains only floats']


nmap cq gcc
vmap cq gcc


let g:nnn#action = {
    \ '<c-t>': 'tab split',
    \ '<c-x>': 'split',
    \ '<c-v>': 'vsplit',
    \ '<c-e>': 'edit' }

let g:nnn#replace_netrw = 1

let g:nnn#command = 'nnn -eoH'
let g:nnn#set_default_mappings = 0
nnoremap <silent> <leader>f :NnnPicker %:p:h<CR>

" Or pass a dictionary with window size
let g:nnn#layout = { 'left': '~40%' } " or right, up, down


let g:indentLine_color_term = 6 " Makes the vertical bars Green from term color 1
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_setConceal = 1
let g:indentLine_conceallevel = 1
let g:indentLine_concealcursor = ""

"" TODO: Play with this
  " nnoremap <silent> <C-> yiw:Rg <C-r>"<CR>
  " vnoremap <silent> <C-> y:Rg <C-r>"<CR>
  "
" map <space>m :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
map <space>m :e %:p:s,.hpp$,.X123X,:s,.cpp$,.hpp,:s,.X123X$,.cpp,<CR>
map ;c <Plug>VimwikiRemoveSingleCB
map ;e <Plug>VimwikiToggleListItem

let g:rg_command = 'rg --vimgrep -S'

" autocmd! FileType fortran
" autocmd  FileType fortran set fdm=syntax foldlevel=2
let g:rg_derive_root = 1
