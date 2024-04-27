vim.cmd("colorscheme habamax")

vim.cmd([[
	let mapleader = " "

	"" Base Settings
	"" ========================================================

	set scrolloff=5
	set relativenumber
	set number
	set showmode
	set showcmd

	set ignorecase
	set smartcase
	set incsearch
	set hlsearch

	set visualbell

	" Use system clipboard
	set clipboard+=unnamed   

	"" Key mappings
	"" ========================================================

	" Redo
	nnoremap U <C-r>

	" Move to beginning/end of line
	nnoremap <C-h> ^
	nnoremap <C-l> $
	vnoremap <C-h> ^
	vnoremap <C-l> $

	" Exit insert mode
	inoremap jk <Esc>
	inoremap kj <Esc>

	" Move cursor in insert mode
	inoremap <C-h> <left>
	inoremap <C-l> <right>
	inoremap <C-k> <up>
	inoremap <C-j> <down>

	" Delete character backwards in insert mode
	inoremap <C-b> <C-h>

	" Delete character forwards in insert mode
	inoremap <C-n> <Del>

	" Move up and down by x lines
	nnoremap J 5j
	nnoremap K 5k
	vnoremap J 5j
	vnoremap K 5k

	" Move left and right by x words
	nnoremap H 2b
	nnoremap L 2w
	vnoremap H 2b
	vnoremap L 2w

	" Scroll up and down
	nnoremap <C-j> <C-d>
	nnoremap <C-k> <C-u>
	nnoremap <C-d> <C-f>
	nnoremap <C-f> <C-b>
	vnoremap <C-j> <C-d>
	vnoremap <C-k> <C-u>
	vnoremap <C-d> <C-f>
	vnoremap <C-f> <C-b>

	" Close active editor
	nmap <C-w> :tabclose<CR>

	" Tab navigation
	nnoremap <C-n> :tabnext<CR>
	nnoremap <C-b> :tabprev<CR>
	vnoremap <C-n> :tabnext<CR>
	vnoremap <C-b> :tabprev<CR>

	" Move between splits
	nnoremap <C-u> <Nop>
	nnoremap <C-u>h <C-w>h
	nnoremap <C-u>l <C-w>l
	nnoremap <C-u>k <C-w>k
	nnoremap <C-u>j <C-w>j
	vnoremap <C-u> <Nop>
	vnoremap <C-u>h <C-w>h
	vnoremap <C-u>l <C-w>l
	vnoremap <C-u>k <C-w>k
	vnoremap <C-u>j <C-w>j

	" Easy visual indentation
	vnoremap < <gv
	vnoremap > >gv

	" Execute macro saved in 'q' register
	nnoremap qj @q

	"" Leader commands
	"" ========================================================

	" New line
	nnoremap <leader>o o<Esc>
	nnoremap <leader>O O<Esc>

	" Join lines
	nnoremap <leader>j J

	" Split lines
	nnoremap <leader>k i<Enter><Esc>k$

	" Remove highlight
	map <leader>/ :noh<CR>

	" Open register
	map <leader>' :reg<CR>
]])

vim.cmd([[
	" Highlight yanked text
	au TextYankPost * silent! lua vim.highlight.on_yank()
]])

require 'user.reload'
vim.keymap.set('n', '<leader>rc', ':lua ReloadConfig()<CR>', { noremap = true, silent = false })
