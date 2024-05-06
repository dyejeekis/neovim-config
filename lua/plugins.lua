return {
	-- No config plugins
	-- 'pocco81/auto-save.nvim',
	'tpope/vim-rhubarb',

	{ -- Theme
		'EdenEast/nightfox.nvim',
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
			-- Load the colorscheme here.
			vim.cmd.colorscheme 'carbonfox'

			-- You can configure highlights by doing something like:
			-- vim.cmd.hi 'Comment gui=none'
		end,
	},

	{ -- Enable transparent background for all themes
		'xiyaowong/transparent.nvim',
		lazy = false,
		config = function ()
			vim.g.transparent_enabled = true
		end
	},

	{ 'numToStr/Comment.nvim', opts = {} },

	{
		'tpope/vim-fugitive',
		config = function ()
			vim.keymap.set('n', '<leader>fd', '<cmd>Git difftool<CR>', { desc = '[F]ocus [D]ifftool'})
		end
	},

	{ -- Git diff utilities
		'lewis6991/gitsigns.nvim',
		opts = {
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
		},
		config = function ()
			-- todo: set more keymaps
			vim.keymap.set('n', '<leader>vv', '<cmd>Gitsigns preview_hunk_inline<CR>', { desc = '[V] Pre[V]iew hunk inline'})
			vim.keymap.set('n', '<leader>vn', '<cmd>Gitsigns next_hunk<CR>', { desc = '[V] [N]ext hunk'})
			vim.keymap.set('n', '<leader>vp', '<cmd>Gitsigns prev_hunk<CR>', { desc = '[V] [P]revious hunk'})
			vim.keymap.set('n', '<leader>vr', '<cmd>Gitsigns reset_hunk<CR>', { desc = '[V] [R]eset hunk'})
			vim.keymap.set('n', '<leader>vd', '<cmd>Gitsigns diffthis<CR>', { desc = '[V] Show [D]iff'})

			require('gitsigns').setup()
		end
	},

	{ -- Fuzzy Finder (files, lsp, etc)
		'nvim-telescope/telescope.nvim',
		event = 'VimEnter',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},
			{ 'nvim-telescope/telescope-ui-select.nvim' },
		},
		config = function()
			-- The easiest way to use Telescope, is to start by doing something like:
			--  :Telescope help_tags
			--
			-- Two important keymaps to use while in Telescope are:
			--  - Insert mode: <c-/>
			--  - Normal mode: ?
			--
			-- [[ Configure Telescope ]]
			-- See `:help telescope` and `:help telescope.setup()`
			require('telescope').setup {
			--
			-- defaults = {
			--   mappings = {
			--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
			--   },
			-- },
			-- pickers = {}
				extensions = {
					['ui-select'] = {
						require('telescope.themes').get_dropdown(),
					},
				},
			}

			-- Enable Telescope extensions if they are installed
			pcall(require('telescope').load_extension, 'fzf')
			pcall(require('telescope').load_extension, 'ui-select')

			-- Telescope keymaps, see `:help telescope.builtin`
			local builtin = require 'telescope.builtin'
			vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
			vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
			vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
			vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
			vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
			vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
			vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
			vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
			vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
			vim.keymap.set('n', '<leader>sc', builtin.colorscheme, { desc = '[S]earch [C]olorschemes' })

			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set('n', '<leader>s/', function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
					winblend = 0,
					previewer = false,
				})
			end, { desc = '[S]earch [/] Fuzzily in current buffer' })

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set('n', '<leader>so', function()
				builtin.live_grep {
					grep_open_files = true,
					prompt_title = 'Live Grep in Open Files',
				}
			end, { desc = '[S]earch in [O]pen Files' })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set('n', '<leader>sn', function()
				builtin.find_files { cwd = vim.fn.stdpath 'config' }
			end, { desc = '[S]earch [N]eovim files' })
		end,
	},

	{
		-- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ 'williamboman/mason.nvim', config = true },
			'williamboman/mason-lspconfig.nvim',
			'WhoIsSethDaniel/mason-tool-installer.nvim',

			-- Useful status updates for LSP.
			{ 'j-hui/fidget.nvim', opts = {} },

			-- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
			-- used for completion, annotations and signatures of Neovim apis
			{ 'folke/neodev.nvim', opts = {} },
		},
		config = function()
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
				callback = function(event)
					-- NOTE: Remember that Lua is a real programming language, and as such it is possible
					-- to define small helper and utility functions so you don't have to repeat yourself.
					--
					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc)
						vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
					end

					map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
					map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
					map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
					map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
					map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
					map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
					map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
					map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
					map('gh', vim.lsp.buf.hover, 'Hover Documentation')
					map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
						vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd('LspDetach', {
							group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
							end,
						})
					end

					-- The following autocommand is used to enable inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						map('<leader>th', function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
						end, '[T]oggle Inlay [H]ints')
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

			-- Enable the following language servers
			local servers = {
			-- clangd = {},
			-- gopls = {},
			-- pyright = {},
			-- rust_analyzer = {},
			-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
			--
			-- Some languages (like typescript) have entire language plugins that can be useful:
			--    https://github.com/pmizio/typescript-tools.nvim
			--
			-- But for many setups, the LSP (`tsserver`) will work just fine
			-- tsserver = {},
			--

			-- lua_ls = {
			-- cmd = {...},
			-- filetypes = { ...},
			-- capabilities = {},
			-- settings = {
			--   Lua = {
			--     completion = {
			--       callSnippet = 'Replace',
			--     },
			--     -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
			--     -- diagnostics = { disable = { 'missing-fields' } },
			--   },
			-- },
			-- },
			}

			-- Ensure the servers and tools above are installed
			require('mason').setup()

			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			-- vim.list_extend(ensure_installed, {
			-- 	'stylua', -- Used to format Lua code
			-- })
			require('mason-tool-installer').setup { ensure_installed = ensure_installed }

			require('mason-lspconfig').setup {
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for tsserver)
						server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
						require('lspconfig')[server_name].setup(server)
					end,
				},
			}
		end,
	},

	{
		-- Autocompletion
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			-- Adds other completion capabilities.
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',
		},
		config = function()
			-- See `:help cmp`
			local cmp = require 'cmp'
			local luasnip = require 'luasnip'
			luasnip.config.setup {}

			cmp.setup {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = 'menu,menuone,noinsert' },

				-- For an understanding of why these mappings were
				-- chosen, you will need to read `:help ins-completion`
				mapping = cmp.mapping.preset.insert {
					-- -- Select the [n]ext item
					-- ['<C-n>'] = cmp.mapping.select_next_item(),
					-- -- Select the [p]revious item
					-- ['<C-p>'] = cmp.mapping.select_prev_item(),
					--
					-- -- Scroll the documentation window [b]ack / [f]orward
					-- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
					-- ['<C-f>'] = cmp.mapping.scroll_docs(4),
					--
					-- -- Accept ([y]es) the completion.
					-- --  This will auto-import if your LSP supports it.
					-- --  This will expand snippets if the LSP sent a snippet.
					-- ['<C-y>'] = cmp.mapping.confirm { select = true },

					-- If you prefer more traditional completion keymaps
					['<CR>'] = cmp.mapping.confirm { select = true },
					['<Tab>'] = cmp.mapping.select_next_item(),
					['<S-Tab>'] = cmp.mapping.select_prev_item(),

					-- Manually trigger a completion from nvim-cmp.
					['<C-Space>'] = cmp.mapping.complete {},
				},
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'path' },
				},
			}
		end
	},

	{ -- Collection of various small independent plugins/modules
		'echasnovski/mini.nvim',
		config = function()
		  -- Better Around/Inside textobjects
		  --
		  -- Examples:
		  --  - va)  - [V]isually select [A]round [)]paren
		  --  - yinq - [Y]ank [I]nside [N]ext [']quote
		  --  - ci'  - [C]hange [I]nside [']quote
		  require('mini.ai').setup { n_lines = 500 }

		  -- Add/delete/replace surroundings (brackets, quotes, etc.)
		  --
		  -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		  -- - sd'   - [S]urround [D]elete [']quotes
		  -- - sr)'  - [S]urround [R]eplace [)] [']
		  require('mini.surround').setup()

		  -- Simple and easy statusline.
		  --  You could remove this setup call if you don't like it,
		  --  and try some other statusline plugin
		  local statusline = require 'mini.statusline'
		  statusline.setup { use_icons = false }

		  -- You can configure sections in the statusline by overriding their
		  -- default behavior. For example, here we set the section for
		  -- cursor location to LINE:COLUMN
		  ---@diagnostic disable-next-line: duplicate-set-field
		  statusline.section_location = function()
			return '%2l:%-2v'
		  end

		  -- ... and there is more!
		  --  Check out: https://github.com/echasnovski/mini.nvim
		end,
	},
}
