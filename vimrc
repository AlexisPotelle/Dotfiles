set nocompatible        " Désactive la compatibilité avec vi
filetype off

set title               " Mais a jour le titre de votre fenetre ou de votre terminal
set list                " Affiche caractere invisible
set listchars=tab:>─,eol:¬,trail:\ ,nbsp:¤
set number              " Affiche les numéros de ligne
set relativenumber      " Active Numerotation relative
set smartindent         " Indentation intelligente
set smarttab
set autoindent          " Conserve l'indentation sur une nouvelle ligne
set ruler               " Affiche la position du curseur
set mouse=a             " Prise en charge de la souris
set mousehide           " Cache la souris pendant la frappe
syntax on               " Coloration syntaxique
set showcmd             " affiche les commandes incomplète
set ruler               " affiche la position du curseur
set showmatch           " Mettre en évidence les parenthèses qui correspondent
set expandtab           " Conversion des tabulations en espaces
set tabstop=4
set shiftwidth=4        " Indentation de quatre colonnes
" set textwidth=79        " 80, le nombre maximal de caractères par ligne
set cursorline          " Souligne la ligne courrante
set ignorecase          " Recherche insensible à la casse
set incsearch           " Recherche insensible à la casse
set splitright          " Mettre nouveller fenetre vsplit a droite de celle

set encoding=utf-8      " Encodage par défaut des buffers en utf-8
set fileencoding=utf-8  " Encodage par défaut des fichiers en utf-8

set background=dark
set autoread            " Recharge le fichier en cas de modification externe
set wildmenu            " Enhance command line completion
set wildmode=longest:full,list:full
set wildignore=*.o,*#,*~,*.dll,*.so,*.a
set t_Co=256
set diffopt=vertical
set nofoldenable        " Ne rien cacher par défaut

"<=== Configuration Raccourci Clavier ===>
" Aller à l'onglet suivant
nnoremap <C-Left>  :tabprevious<CR>
" Aller à l'onglet précédent
nnoremap <C-Right>  :tabnext<CR>
" Fermer l'onglet courant
nnoremap <C-c> :tabclose<CR>
" Ouvrir un nouvel onglet
nnoremap <C-t> :tabnew<CR>
" Ouvrir l'explorateur de fichier
map <F2> :Vexplore<CR>


set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'thaerkh/vim-indentguides'
Plugin 'w0rp/ale'


Plugin 'ap/vim-css-color'
Plugin 'nanotech/jellybeans.vim'            " Vim theme : colorscheme jellybeans
Plugin 'tomasiser/vim-code-dark'            " Vim theme : colorscheme codedark
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'majutsushi/tagbar'
Plugin 'tpope/vim-fugitive'
Plugin 'valloric/youcompleteme'
Plugin 'fatih/vim-go'
Plugin 'tomtom/tcomment_vim'

Plugin 'rrethy/vim-illuminate'
Plugin 'KabbAmine/vCoolor.vim'


call vundle#end()
filetype plugin indent on

"<=== indentation Configuration ===>
let g:indentguides_spacechar = '│'
let g:indentguides_tabchar = '│'
"<=== Theme Configuration ===>
 let g:jellybeans_background_color_256='232'

" Feel free to switch to another colorscheme
colorscheme codedark
"colorscheme jellybeans
let g:closetag_filenames = '*.html,*.xhtml,*.phtml, *.php'

let g:airline_section_b = '%{strftime("%c")}'
"<========================================>
"<           togglecursor                 >
"<========================================>

if exists('g:loaded_togglecursor') || &cp || !has("cursorshape")
  finish
endif

" Bail out early if not running under a terminal.
if has("gui_running")
    finish
endif

if !exists("g:togglecursor_disable_neovim")
    let g:togglecursor_disable_neovim = 0
endif

if !exists("g:togglecursor_disable_default_init")
    let g:togglecursor_disable_default_init = 0
endif

if has("nvim")
    " If Neovim support is enabled, then let set the
    " NVIM_TUI_ENABLE_CURSOR_SHAPE for the user.
    if $NVIM_TUI_ENABLE_CURSOR_SHAPE == "" && g:togglecursor_disable_neovim == 0
        let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
    endif
    finish
endif

let g:loaded_togglecursor = 1

let s:cursorshape_underline = "\<Esc>]50;CursorShape=2;BlinkingCursorEnabled=0\x7"
let s:cursorshape_line = "\<Esc>]50;CursorShape=1;BlinkingCursorEnabled=0\x7"
let s:cursorshape_block = "\<Esc>]50;CursorShape=0;BlinkingCursorEnabled=0\x7"

let s:cursorshape_blinking_underline = "\<Esc>]50;CursorShape=2;BlinkingCursorEnabled=1\x7"
let s:cursorshape_blinking_line = "\<Esc>]50;CursorShape=1;BlinkingCursorEnabled=1\x7"
let s:cursorshape_blinking_block = "\<Esc>]50;CursorShape=0;BlinkingCursorEnabled=1\x7"

" Note: newer iTerm's support the DECSCUSR extension (same one used in xterm).

let s:xterm_underline = "\<Esc>[4 q"
let s:xterm_line = "\<Esc>[6 q"
let s:xterm_block = "\<Esc>[2 q"

" Not used yet, but don't want to forget them.
let s:xterm_blinking_block = "\<Esc>[0 q"
let s:xterm_blinking_line = "\<Esc>[5 q"
let s:xterm_blinking_underline = "\<Esc>[3 q"

let s:in_tmux = exists("$TMUX")

" Detect whether this version of vim supports changing the replace cursor
" natively.
let s:sr_supported = exists("+t_SR")

let s:supported_terminal = ''

" Check for supported terminals.
if exists("g:togglecursor_force") && g:togglecursor_force != ""
    if count(["xterm", "cursorshape"], g:togglecursor_force) == 0
        echoerr "Invalid value for g:togglecursor_force: " .
                \ g:togglecursor_force
    else
        let s:supported_terminal = g:togglecursor_force
    endif
endif

function! s:GetXtermVersion(version)
    return str2nr(matchstr(a:version, '\v^XTerm\(\zs\d+\ze\)'))
endfunction

if s:supported_terminal == ""
    " iTerm, xterm, and VTE based terminals support DECSCUSR.
    if $TERM_PROGRAM == "iTerm.app" || exists("$ITERM_SESSION_ID")
        let s:supported_terminal = 'xterm'
    elseif $TERM_PROGRAM == "Apple_Terminal" && str2nr($TERM_PROGRAM_VERSION) >= 388
        let s:supported_terminal = 'xterm'
    elseif $TERM == "xterm-kitty"
        let s:supported_terminal = 'xterm'
    elseif $TERM == "rxvt-unicode" || $TERM == "rxvt-unicode-256color"
        let s:supported_terminal = 'xterm'
    elseif str2nr($VTE_VERSION) >= 3900
        let s:supported_terminal = 'xterm'
    elseif s:GetXtermVersion($XTERM_VERSION) >= 252
        let s:supported_terminal = 'xterm'
    elseif $TERM_PROGRAM == "Konsole" || exists("$KONSOLE_DBUS_SESSION")
        " This detection is not perfect.  KONSOLE_DBUS_SESSION seems to show
        " up in the environment despite running under tmux in an ssh
        " session if you have also started a tmux session locally on target
        " box under KDE.

        let s:supported_terminal = 'cursorshape'
    endif
endif

if s:supported_terminal == ''
    " The terminal is not supported, so bail.
    finish
endif


" -------------------------------------------------------------
" Options
" -------------------------------------------------------------

if !exists("g:togglecursor_default")
    let g:togglecursor_default = 'blinking_block'
endif

if !exists("g:togglecursor_insert")
    let g:togglecursor_insert = 'blinking_line'
    if $XTERM_VERSION != "" && s:GetXtermVersion($XTERM_VERSION) < 282
        let g:togglecursor_insert = 'blinking_underline'
    endif
endif

if !exists("g:togglecursor_replace")
    let g:togglecursor_replace = 'blinking_underline'
endif

if !exists("g:togglecursor_leave")
    if str2nr($VTE_VERSION) >= 3900
        let g:togglecursor_leave = 'blinking_block'
    else
        let g:togglecursor_leave = 'block'
    endif
endif

if !exists("g:togglecursor_disable_tmux")
    let g:togglecursor_disable_tmux = 0
endif

" -------------------------------------------------------------
" Functions
" -------------------------------------------------------------

function! s:TmuxEscape(line)
    " Tmux has an escape hatch for talking to the real terminal.  Use it.
    let escaped_line = substitute(a:line, "\<Esc>", "\<Esc>\<Esc>", 'g')
    return "\<Esc>Ptmux;" . escaped_line . "\<Esc>\\"
endfunction

function! s:SupportedTerminal()
    if s:supported_terminal == '' || (s:in_tmux && g:togglecursor_disable_tmux)
        return 0
    endif

    return 1
endfunction

function! s:GetEscapeCode(shape)
    if !s:SupportedTerminal()
        return ''
    endif

    let l:escape_code = s:{s:supported_terminal}_{a:shape}

    if s:in_tmux
        return s:TmuxEscape(l:escape_code)
    endif

    return l:escape_code
endfunction

function! s:ToggleCursorInit()
    if !s:SupportedTerminal()
        return
    endif

    let &t_EI = s:GetEscapeCode(g:togglecursor_default)
    let &t_SI = s:GetEscapeCode(g:togglecursor_insert)
    if s:sr_supported
        let &t_SR = s:GetEscapeCode(g:togglecursor_replace)
    endif
endfunction

function! s:ToggleCursorLeave()
    " One of the last codes emitted to the terminal before exiting is the "out
    " of termcap" sequence.  Tack our escape sequence to change the cursor type
    " onto the beginning of the sequence.
    let &t_te = s:GetEscapeCode(g:togglecursor_leave) . &t_te
endfunction

function! s:ToggleCursorByMode()
    if v:insertmode == 'r' || v:insertmode == 'v'
        let &t_SI = s:GetEscapeCode(g:togglecursor_replace)
    else
        " Default to the insert mode cursor.
        let &t_SI = s:GetEscapeCode(g:togglecursor_insert)
    endif
endfunction

" Setting t_ti allows us to get the cursor correct for normal mode when we first
" enter Vim.  Having our escape come first seems to work better with tmux and
" Konsole under Linux.  Allow users to turn this off, since some users of VTE
" 0.40.2-based terminals seem to have issues with the cursor disappearing in the
" certain environments.
if g:togglecursor_disable_default_init == 0
    let &t_ti = s:GetEscapeCode(g:togglecursor_default) . &t_ti
endif

augroup ToggleCursorStartup
    autocmd!
    autocmd VimEnter * call <SID>ToggleCursorInit()
    autocmd VimLeave * call <SID>ToggleCursorLeave()
    if !s:sr_supported
        autocmd InsertEnter * call <SID>ToggleCursorByMode()
    endif
augroup END


"<========================================>
"<           AUTO-CLOSE { ( [ ' "         >
"<========================================>

set showmatch           " Mettre en évidence les parenthèses qui correspondent
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap { {<cr>}<esc>O
inoremap ' ''<LEFT>
inoremap " ""<LEFT>
inoremap ` ``<LEFT>


