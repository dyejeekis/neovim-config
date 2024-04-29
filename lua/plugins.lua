return {
	-- No config plugins
	'pocco81/auto-save.nvim',
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',

	{ 'numToStr/Comment.nvim', opts = {} },

	{ 'lewis6991/gitsigns.nvim', config = true },
	
	{
		-- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ 'williamboman/mason.nvim', config = true },
			'williamboman/mason-lspconfig.nvim',
		},
	},

	{
		-- Autocompletion
		'hrsh7th/nvim-cmp',
		dependencies = {
			-- Adds LSP completion capabilities
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',
		}
	},

	{
		-- Set lualine as statusline
		'nvim-lualine/lualine.nvim',
		opts = {
			options = {
				icons_enabled = false,
				theme = 'auto',
				component_separators = '|',
				section_separators = '',
			},
		},
	},

}
