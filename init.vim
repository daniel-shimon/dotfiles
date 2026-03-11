call plug#begin('~/.vim/plugged')

Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/argtextobj.vim'
Plug 'f-person/auto-dark-mode.nvim'
Plug 'lewis6991/gitsigns.nvim'

call plug#end()

" Configure auto-dark-mode.nvim with SSH session detection
lua << EOF
local ok_gs, gitsigns = pcall(require, 'gitsigns')
if ok_gs then
    gitsigns.setup()
end

local ok, auto_dark_mode = pcall(require, 'auto-dark-mode')
if ok then
    auto_dark_mode.setup({
    update_interval = 1000,
    })
    -- Initialize with current appearance
    auto_dark_mode.init()
end
EOF

" Ensure proper color support in terminal
if has('termguicolors')
  set termguicolors
endif

" Fix colors in tmux
if &term =~ '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen.
  set t_ut=
endif

" Clipboard handling (cutlass vibes)
noremap y "+y
noremap yy "+yy
noremap Y "+y$
noremap m "+d
noremap mm "+dd
noremap M "+D
noremap p "+p
noremap P "+P

" Remap multiple-cursors shortcuts to match terryma/vim-multiple-cursors
nmap <C-n> <Plug>NextWholeOccurrence
xmap <C-n> <Plug>NextWholeOccurrence
nmap g<C-n> <Plug>NextOccurrence
xmap g<C-n> <Plug>NextOccurrence
xmap <C-x> <Plug>SkipOccurrence
xmap <C-p> <Plug>RemoveOccurrence
" Note that the default <A-n> and g<A-n> shortcuts don't work on Mac due to dead keys.
" <A-n> is used to enter accented text e.g. ñ
nmap <S-C-n> <Plug>AllWholeOccurrences
xmap <S-C-n> <Plug>AllWholeOccurrences
nmap g<S-C-n> <Plug>AllOccurrences
xmap g<S-C-n> <Plug>AllOccurrences


