-- Vim settings
vim.cmd([[
	let mapleader = " "

	"" Base Settings
	"" ========================================================

	set tabstop=4
	set shiftwidth=4
	set scrolloff=5
	set relativenumber
	set number
	set noshowmode
	set showcmd

	set ignorecase
	set smartcase
	set incsearch
	set hlsearch

	set visualbell

	" Use system clipboard
	set clipboard^=unnamed,unnamedplus

	"" Key mappings
	"" ========================================================

	" Exit terminal-mode
    tnoremap <Esc> <C-\><C-n>

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
	inoremap <C-n> <C-h>

	" Delete character forwards in insert mode
	inoremap <C-b> <Del>

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
	nnoremap <C-u> <C-y>
	nnoremap <C-y> <C-e>
	vnoremap <C-j> <C-d>
	vnoremap <C-k> <C-u>
	vnoremap <C-d> <C-f>
	vnoremap <C-f> <C-b>
	vnoremap <C-u> <C-y>
	vnoremap <C-y> <C-e>

	" Easy visual indentation
	vnoremap < <gv
	vnoremap > >gv

	" Execute macro saved in 'q' register
	nnoremap qj @q

	" New line
	nnoremap <leader>o o<Esc>
	nnoremap <leader>O O<Esc>

	" Join lines
	nnoremap <leader>j J

	" Split lines
	nnoremap <leader>k i<Enter><Esc>k$

	" Remove highlights
	map <leader>/ :noh<CR>

	" Show registers
	map <leader>' :reg<CR>

	" Tabs
	" nnoremap <C-n> :tabn<CR>
	" nnoremap <C-p> :tabp<CR>
	map <leader>tt :tabs<CR>
	map <leader>te :tabe<CR>
	map <leader>tE :$tabe<CR>
	map <leader>tn :tabn<CR>
	map <leader>tp :tabp<CR>
	map <leader>tc :tabc<CR>
	map <leader>to :tabo<CR>
	map <leader>tm :tabm<CR>
	map <leader>ts :tab split<CR>

	" Buffers
	map <leader>bb :ls<CR>
	map <leader>be :ene<CR>
	map <leader>bn :bn<CR>
	map <leader>bp :bp<CR>
	map <leader>bd :bd<CR>
	map <leader>bw :bw!<CR>

	" Write buffer
	map <leader>ww :up<CR>
	map <leader>wa :wa<CR>

	" Exit vim
	map <leader>qq :qa<CR>
	map <leader>QQ :qa!<CR>

	" Other actions
	map <leader>aa gg<S-v><S-g>
]])

-- Use powershell as terminal
if vim.fn.has 'win32' == 1 then
	vim.cmd([[
		let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
		let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';'
		let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
		let &shellpipe  = '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode'
		set shellquote= shellxquote=
	]])
end

-- Startup autocommands
vim.cmd([[
	" Highlight yanked text
	au TextYankPost * silent! lua vim.highlight.on_yank()

	" Enable relative line numbers only for active buffer
	augroup number_toggle
		autocmd!
		autocmd BufEnter,WinEnter,FocusGained,InsertLeave * set relativenumber
		autocmd BufLeave,WinLeave,FocusLost,InsertEnter * set norelativenumber
	augroup END

	" Disable netrw file explorer
	augroup goodbye_netrw
		au!
		autocmd VimEnter * silent! au! FileExplorer *
	augroup END
]])

-- Open home screen
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup('open-home-screen', { clear = true }),
    callback = function()
		-- Ensure exactly one argument is passed and it's a directory
        if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
            -- require("telescope.builtin").find_files()
			vim.cmd("lua MiniStarter.open()") -- Open mini.starter
        end
    end
})

-- Autosave
vim.keymap.set('n', '<leader>ae', function ()
	vim.cmd([[
		augroup autosave
			autocmd!
			autocmd TextChanged,TextChangedI * silent! update
		augroup END
	]])
	print('Autosave enabled')
end, { desc = '[A]utosave [E]nable' })

vim.keymap.set('n', '<leader>ad', function ()
	vim.cmd([[
		silent! autocmd! autosave
	]])
	print('Autosave disabled')
end, { desc = '[A]utosave [D]isable' })

-- Diagnostics config
vim.diagnostic.config({ virtual_text = true })

-- Toggle diagnostics
vim.keymap.set('n', '<leader>nt', function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true })

-- Show floating diagnostics
vim.keymap.set('n', '<leader>nf', function()
	vim.diagnostic.open_float()
end, { silent = true, noremap = true })

-- Reload config script
require 'user.reload'
vim.keymap.set('n', '<leader>rc', ':lua ReloadConfig()<CR>', { noremap = true, silent = false })

-- Install `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configure plugins
require('lazy').setup('plugins')
