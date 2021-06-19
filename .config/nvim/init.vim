" vim: fdm=marker

" ███    ██  ███████   ██████   ██    ██  ██  ███    ███    
" ████   ██  ██       ██    ██  ██    ██  ██  ████  ████    
" ██ ██  ██  █████    ██    ██  ██    ██  ██  ██ ████ ██    
" ██  ██ ██  ██       ██    ██   ██  ██   ██  ██  ██  ██    
" ██   ████  ███████   ██████     ████    ██  ██      ██    

" Check out https://github.com/gillescastel/latex-snippets
" Better compatibility with remote servers: Simpler vimrc
" TODO: https://github.com/bkad/CamelCaseMotion or https://github.com/chaoren/vim-wordmotion
" TODO: Plug 'voldikss/vim-floaterm'
" TODO: https://github.com/junegunn/vim-peekaboo
" TODO: https://github.com/stefandtw/quickfix-reflector.vim
" TODO: Vimspector + Telescope
" https://github.com/d0c-s4vage/lookatme
" https://github.com/b3nj5m1n/kommentary
" https://github.com/alpertuna/vim-header
" https://github.com/garbas/vim-snipmate

" Plugins :{{{
set nocompatible              " be iMproved, required
filetype off                  " required

" With a map leader it's possible to do extra key combinations
" " like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

call plug#begin('~/.config/nvim/bundle')

" Custom: plugin for task tags 
Plug 'jayghoshter/tasktags.vim'     

" Basic: LSP, Completion and Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'

" Telescope: It's dope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-github.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" Tpope's plugins are de-facto standard
Plug 'tpope/vim-commentary'                                   
Plug 'tpope/vim-surround'                                     
Plug 'tpope/vim-unimpaired'                                   
Plug 'tpope/vim-fugitive'                                     
Plug 'tpope/vim-repeat'                                      
Plug 'tpope/vim-obsession'                                   

" Languages: 
Plug 'lervag/vimtex'
Plug 'vim-pandoc/vim-pandoc'
Plug 'mboughaba/i3config.vim'           " [REVW]

Plug 'wellle/targets.vim'               " [REVW]
Plug 'Raimondi/delimitMate'                                 
Plug 'vim-scripts/argtextobj.vim'

" General utilities
Plug 'jremmen/vim-ripgrep'
Plug 'rbong/vim-crystalline'
Plug 'Valloric/ListToggle' 
Plug 'lambdalisue/suda.vim'
Plug 'mcchrish/nnn.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'skywind3000/asyncrun.vim'
Plug 'tommcdo/vim-lion'                                       

" Provide indentlines. 
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'Yggdroot/indentLine'

" Beautiful distraction-free mode
Plug 'junegunn/goyo.vim'                                    
Plug 'junegunn/limelight.vim'                              

" " Colorschemes
Plug 'arcticicestudio/nord-vim'                               " theme
" Plug 'shaunsingh/nord.nvim'

" Deprecated Plugins: {{{

" Plug 'idanarye/vim-omnipytent'                                " build system
" Plug 'universal-ctags/ctags'
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'

" }}}
"
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
" Crystalline: {{{
function! StatusLine(current, width)
  let l:s = ''

  if a:current
    let l:s .= crystalline#mode() . crystalline#right_mode_sep('')
  else
    let l:s .= '%#CrystallineInactive#'
  endif
  let l:s .= ' %f%h%w%m%r '
  if a:current
    let l:s .= crystalline#right_sep('', 'Fill') . ' %{fugitive#head()}'
  endif

  let l:s .= '%='
  if a:current
    let l:s .= crystalline#left_sep('', 'Fill') . ' %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
    let l:s .= crystalline#left_mode_sep('')
  endif
  if a:width > 80
    let l:s .= ' %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
  else
    let l:s .= ' '
  endif

  return l:s
endfunction
let g:crystalline_statusline_fn = 'StatusLine'

let g:crystalline_enable_sep = 1
let g:crystalline_theme = 'nord'
set tabline=%!crystalline#bufferline()
set statusline=%!crystalline#StatusLine()
set showtabline=2
set guioptions-=e
set laststatus=2
" }}}

call plug#end()            " required

" }}}

"Set Options: {{{

"set t_Co=256

let g:nord_italic=1
let g:nord_italic_comments=1
" let g:nord_underline=1

" let g:nord_comment_brightness=5

augroup nord-overrides
    autocmd!
    " autocmd ColorScheme nord highlight Folded cterm=italic ctermbg=0 ctermfg=12 guibg=#3B4252 guifg=#b5b5b5
    autocmd ColorScheme nord highlight Folded ctermbg=0 ctermfg=12 guibg=#3B4252 guifg=#b5b5b5
augroup END

" nord.nvim settings
let g:nord_contrast = 1
let g:nord_borders = 1

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
set laststatus=2          " use 2 for airline, 0 otherwise
set inccommand=split
set clipboard=unnamedplus		"register = clipboard"
set completeopt=noinsert,menuone,noselect
set timeout timeoutlen=800 ttimeoutlen=10
set updatetime=300        " Smaller updatetime for CursorHold & CursorHoldI
set spelllang=en_gb
set conceallevel=2
set signcolumn=yes          " always show signcolumns: helps with linters for error signs >>
set shortmess+=c
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

set formatoptions+=cro          " Autoinsert commentstring on 'o'

" Search down into subfolders
" Provides tab-completion for all file related tasks
set path+=**

" Fixes common backspace problems
set backspace=indent,eol,start

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

"}}}

syntax on                 "neovim default on

"}}}

"Mappings: {{{

map j gj
map k gk

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
inoremap :; ::
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

tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
" tnoremap <Tab> <C-\><C-n>:bnext<CR>
tnoremap <S-Tab> <C-\><C-n>:bprevious<CR>
tnoremap <leader>q :q<cr>

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
" Create non-existent directories before writing. Avoids an annoying error.
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

" Autocmds: {{{
" Open read-only automatically if swapfile exists
autocmd SwapExists * let v:swapchoice = "o"  

" autocmd BufRead,BufNewFile *.in set filetype=conf
" autocmd Filetype tex set filetype=plaintex.tex
autocmd Filetype conf,cmake,xns set commentstring=#\ %s
autocmd Filetype tex set commentstring=%%\ %s
au BufNewFile,BufRead xns*.in* set filetype=xns

"}}}

"Asyncrun functions:{{{
let g:asyncrun_rootmarks = ['.git', '.root']
let g:asyncrun_bell=20
let g:asyncrun_trim=1
let g:asyncrun_open=0

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
	autocmd! BufWritePost *.tex execute 'AsyncRun pdflatex %'
	autocmd! User AsyncRunStop :call <SID>AsyncQuickFix()
augroup END

"}}}

"Pandoc:{{{

let g:pandoc#syntax#conceal#use = 1
let g:pandoc#syntax#style#use_definition_lists = 0
let g:pandoc#syntax#conceal#urls = 1
let g:pandoc#formatting#mode = "sA"
let g:pandoc#formatting#smart_autoformat_on_cursormoved = 1
let g:pandoc#command#use_message_buffers=1
let g:pandoc#folding#level = 1
let g:pandoc#folding#fold_vim_markers = 1
let g:pandoc#folding#vim_markers_in_comments_only = 1
let g:pandoc#spell#enabled = 0
let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
" let g:pandoc#command#autoexec_command = "Pandoc! pdf"

augroup markdown

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

" Tmux Navigation: {{{
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

" ListToggle: {{{
let g:lt_location_list_toggle_map = '<space>w'
let g:lt_quickfix_list_toggle_map = '<space>q'
let g:lt_height = 10
" }}}

" TeX/VimTex: {{{ 

" let g:tex_flavor = "latex"
" let g:tex_indent_brace = 1 
" let g:tex_indent_items = 1
" let g:tex_items = 1
" let g:tex_itemize_env = 1 
" " let g:tex_noindent_env 

" Nord conceal colors
highlight Conceal guifg=#81A1C1 guibg=#2E3440

let g:vimtex_fold_enabled = 1
let g:vimtex_log_ignore = [ 'Underfull', 'contains only floats' ]
let g:vimtex_quickfix_ignore_filters = [ 'Underfull', 'contains only floats']

" }}}

" nnn: {{{
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

" }}}

" Indent lines: {{{

let g:indentLine_enabled = 1 
let g:indentLine_setConceal = 1
let g:indentLine_conceallevel = 1
let g:indentLine_concealcursor = ""
let g:indentLine_char_list = ["▏"]

let g:indent_blankline_show_first_indent_level = v:false
let g:indent_blankline_show_trailing_blankline_indent = v:false
let g:indent_blankline_use_treesitter = v:true
let g:indent_blankline_char_list = ["▏"]

" }}}

" Ripgrep: {{{
let g:rg_command = 'rg --vimgrep -S'
let g:rg_derive_root = 1
" }}}

""FZF:{{{

"nnoremap <silent> <space>o :Files<CR>
"nnoremap <silent> <space>p :GFiles<CR>
"nnoremap <silent> <space>h :History<CR>
"nnoremap <silent> <space>/ :History/<CR>
"nnoremap <silent> <space>; :History:<CR>
"nnoremap <space>f :Find<space>
"nnoremap <c-e> :FZFLines<CR>

"" Insert mode completion
"imap <c-x><c-k> <plug>(fzf-complete-word)
"imap <c-x><c-f> <plug>(fzf-complete-path)
"imap <c-x><c-j> <plug>(fzf-complete-file-ag)
"imap <c-x><c-l> <plug>(fzf-complete-line)

"" nnoremap <silent> <space>g :exe 'GFiles ' . <SID>fzf_root()<CR>
"" nnoremap <silent> <space>c :Commands<CR>


"" fzf-setup: {{{

"fun! s:fzf_root()
"    let path = finddir(".git", expand("%:p:h").";")
"    return fnamemodify(substitute(path, ".git", "", ""), ":p:h")
"endfun

"" This is the default extra key bindings
"let g:fzf_action = {
"            \ 'ctrl-t': 'tab split',
"            \ 'ctrl-x': 'split',
"            \ 'ctrl-v': 'vsplit' }

"" Open fzf in new window
"let g:fzf_layout = { 'window': 'enew' }

"" Customize fzf colors to match your color scheme
"let g:fzf_colors =
"            \ { 'fg':      ['fg', 'Normal'],
"            \ 'bg':      ['bg', 'Normal'],
"            \ 'hl':      ['fg', 'Comment'],
"            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
"            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
"            \ 'hl+':     ['fg', 'Statement'],
"            \ 'info':    ['fg', 'PreProc'],
"            \ 'border':  ['fg', 'Ignore'],
"            \ 'prompt':  ['fg', 'Conditional'],
"            \ 'pointer': ['fg', 'Exception'],
"            \ 'marker':  ['fg', 'Keyword'],
"            \ 'spinner': ['fg', 'Label'],
"            \ 'header':  ['fg', 'Comment'] }

"" }}}

"" fzf-let opts: {{{
"" [Buffers] Jump to the existing window if possible
"let g:fzf_buffers_jump = 1

"" [[B]Commits] Customize the options used by 'git log':
"let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

"" [Tags] Command to generate tags file
"let g:fzf_tags_command = 'ctags -R'

"" [Commands] --expect expression for directly executing the command
"let g:fzf_commands_expect = 'alt-enter,ctrl-x'

"" Enable per-command history.
"" CTRL-N and CTRL-P will be automatically bound to next-history and
"" previous-history instead of down and up. If you don't like the change,
"" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.

"let g:fzf_history_dir = '~/.local/share/fzf-history'

"" }}}

"" TODO: Add preview to these things
"" fzf-notes: {{{
"" command! -nargs=* Notes :FZF -e -1 -0 $NOTES_DIR
"" command! -bang -nargs=? -complete=dir Notes call fzf#vim#files($NOTES_DIR, {'source': 'rg --files --iglob !*.png --iglob !*.pdf --iglob !*.jpg'}, <bang>0)
"command! -bang -nargs=? -complete=dir Notes call fzf#vim#files($NOTES_DIR, {'source': 'rg --files *.md'}, <bang>0)
"command! -nargs=* Note :e $NOTES_DIR/<args>.md | :Goyo
"nnoremap <space>n :Notes<CR>
"" }}}
"" fzf-find: {{{

"command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

"command! -bang -nargs=* BL call fzf#vim#grep('mdl "'. expand('%:p') .'" '.shellescape(<q-args>), 1, <bang>0)
"command! -bang -nargs=* FL call fzf#vim#grep('mdl "'. expand('%:p') .'" -f', 1, <bang>0)

"nnoremap <space>j :FL<CR>
"nnoremap <space>k :BL<CR>

"" }}}

"""FZFLine:{{{
"function! s:line_handler(l)
"  let keys = split(a:l, ':\t')
"  exec 'buf' keys[0]
"  exec keys[1]
"  normal! ^zz
"endfunction

"function! s:buffer_lines()
"  let res = []
"  for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
"    call extend(res, map(getbufline(b,0,"$"), 'b . ":\t" . (v:key + 1) . ":\t" . v:val '))
"  endfor
"  return res
"endfunction

"command! FZFLines call fzf#run({
"\   'source':  <sid>buffer_lines(),
"\   'sink':    function('<sid>line_handler'),
"\   'options': '--extended --nth=3..',
"\   'down':    '40%'})
"" }}}

"command! -bang -nargs=? -complete=dir Fopen call fzf#vim#files($HOME, {'source': 'fd . ~'}, <bang>0)

""}}}

if has('nvim-0.5')

" Treesitter: {{{
lua <<EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ignore_install = { "javascript" }, -- List of parsers to ignore installing
    highlight = {
    enable = true,              -- false will disable the whole extension
    -- disable = {},  -- list of language that will be disabled
    },
  incremental_selection = {
      enable = true,
      keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
          },
  },
  indent = {
  enable = true,
  }
}
EOF
" }}}

" Telescope:{{{ 
lua<<EOF
local actions = require('telescope.actions')
require('telescope').setup{
    defaults = {
        mappings = {
            i = {
                ['<C-q>'] = actions.send_to_qflist,
                ["<esc>"] = actions.close,
            },
        },
        ...
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}
require('telescope').load_extension('fzy_native')
EOF

nnoremap <space>o <cmd>Telescope find_files<cr>
nnoremap <space>p <cmd>Telescope git_files<cr>
nnoremap <space>f <cmd>Telescope live_grep<cr>
nnoremap <space>l <cmd>Telescope buffers<cr>
nnoremap <space>h <cmd>Telescope help_tags<cr>
nnoremap <space>e <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <C-e>    <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <space>m <cmd>Telescope marks<cr>
nnoremap <space>; <cmd>Telescope command_history<cr>
nnoremap <space>/ <cmd>Telescope search_history<cr>
nnoremap <space>b <cmd>Telescope builtin<cr>

" Telescope GitHub
lua require('telescope').load_extension('gh')
nnoremap <space>gi <cmd>Telescope gh issues<cr>
nnoremap <space>gp <cmd>Telescope gh pull_request<cr>
nnoremap <space>gg <cmd>Telescope gh gist<cr>

nnoremap <space>t :lua require("custom.telescope").project_files()<cr>

" [TASK]: This is obsoleted by Git status built-in. Remove it
nnoremap <space>gd :lua require("custom.telescope").git_dirty()<cr>

nnoremap <space>s <cmd>Telescope lsp_workspace_symbols<cr>

" }}}

" LSPConfig: {{{
lua << EOF
require'lspconfig'.pyright.setup{}
require'lspconfig'.ccls.setup{}
require'lspconfig'.fortls.setup{}

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  -- buf_set_keymap('n', '<C-j>', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<space>y', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  -- buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "pyright", "ccls", "fortls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end

EOF
"}}}

" Compe: {{{

let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:true

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm({ 'keys': "\<Plug>delimitMateCR", 'mode': '' })
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" }}}

endif

" Completion:{{{

inoremap <silent><expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr><s-tab> pumvisible() ? "\<C-p>" : "\<TAB>"
" If you prefer the Omni-Completion tip window to close when a selection is
" " made, these lines close it on movement in insert mode or when leaving
" " insert mode
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" }}}

nnoremap <leader>r :Gcd<cr>
map ;c <Plug>VimwikiRemoveSingleCB
map ;e <Plug>VimwikiToggleListItem

