call plug#begin('~/.vim/plugged')

Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/argtextobj.vim'
Plug 'f-person/auto-dark-mode.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'windwp/nvim-autopairs'
Plug 'lukas-reineke/indent-blankline.nvim'

call plug#end()

" Configure auto-dark-mode.nvim with SSH session detection
lua << EOF
local ok_gs, gitsigns = pcall(require, 'gitsigns')
if ok_gs then gitsigns.setup() end

local ok_ap, autopairs = pcall(require, 'nvim-autopairs')
if ok_ap then autopairs.setup() end

local ok_ibl, ibl = pcall(require, 'ibl')
if ok_ibl then ibl.setup() end

local ok_ts, tsconfigs = pcall(require, 'nvim-treesitter.configs')
if ok_ts then
    tsconfigs.setup({
        ensure_installed = { 'python', 'lua', 'javascript', 'typescript', 'json', 'yaml', 'bash', 'vim', 'markdown', 'markdown_inline', 'diff' },
        highlight = { enable = true },
        indent = { enable = true },
    })
end

local ok_ctp, catppuccin = pcall(require, 'catppuccin')
if ok_ctp then catppuccin.setup() end

local ok, auto_dark_mode = pcall(require, 'auto-dark-mode')
if ok then
    auto_dark_mode.setup({
        update_interval = 1000,
        set_dark_mode_callback = function()
            vim.cmd('colorscheme catppuccin-mocha')
        end,
        set_light_mode_callback = function()
            vim.cmd('colorscheme catppuccin-latte')
        end,
    })
    auto_dark_mode.init()
end

local appearance = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null"):gsub("%s+", "")
if appearance == "Dark" then
    vim.cmd('colorscheme catppuccin-mocha')
else
    vim.cmd('colorscheme catppuccin-latte')
end
EOF

set number
set relativenumber

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


