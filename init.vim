call plug#begin('~/.vim/plugged')

Plug 'terryma/vim-multiple-cursors'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/argtextobj.vim'

call plug#end()

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


