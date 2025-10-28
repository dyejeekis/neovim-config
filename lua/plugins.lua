local DEFAULT_COLORSCHEME = 'terafox'

return {
	-- No config plugins
	'tpope/vim-rhubarb',

	{ -- Enable transparent background for all themes
		'xiyaowong/transparent.nvim',
		dependencies = {
			-- Themes
			-- 'folke/tokyonight.nvim',
			'EdenEast/nightfox.nvim',
			'ellisonleao/gruvbox.nvim',
			'Mofiqul/dracula.nvim',
			-- 'Shatur/neovim-ayu',
			'rebelot/kanagawa.nvim',
			'bluz71/vim-moonfly-colors',
			-- 'bluz71/vim-nightfly-colors',
			-- 'scottmckendry/cyberdream.nvim',
			'olimorris/onedarkpro.nvim',
			'xero/miasma.nvim',
			'vague2k/vague.nvim',
			-- 'patstockwell/vim-monokai-tasty',
			{ 'catppuccin/nvim', name = 'catppuccin' },
			{
				'sainnhe/everforest',
				config = function ()
					vim.api.nvim_create_user_command("EverforestBackground", function(opts)
					  local bg = opts.args
					  if bg ~= "light" and bg ~= "dark" then
						print("Invalid background: choose light or dark")
						return
					  end
					  vim.o.background = bg
					  vim.cmd("colorscheme everforest")
					  print("Everforest background set to " .. bg)
					end, {
					  nargs = 1,
					  complete = function()
						return { "light", "dark" }
					  end,
					})

					vim.api.nvim_create_user_command("EverforestContrast", function(opts)
					  local contrast = opts.args
					  if contrast ~= "hard" and contrast ~= "medium" and contrast ~= "soft" then
						print("Invalid contrast: choose hard, medium, or soft")
						return
					  end
					  vim.g.everforest_background = contrast
					  vim.cmd("colorscheme everforest")
					  print("Everforest contrast set to " .. contrast)
					end, {
					  nargs = 1,
					  complete = function()
						return { "hard", "medium", "soft" }
					  end,
					})

				    local available_presets = {
						["1"] = [[
							EverforestBackground dark
							EverforestContrast medium
							TransparentEnable
						]],
						["2"] = [[
							EverforestBackground light
							EverforestContrast soft
							TransparentDisable
						]],
					}
					vim.api.nvim_create_user_command("EverforestPreset", function(opts)
					  local selected_preset = available_presets[opts.args]
					  if not selected_preset then
						print("Invalid preset")
						return
					  end
					  vim.cmd(selected_preset)
					end, {
					  nargs = 1,
					  complete = function()
						return { "1", "2" }
					  end,
					})
				end
			},
		},
		priority = 1000,
		lazy = false,
		config = function ()
			-- Load the colorscheme here.
			vim.cmd.colorscheme(DEFAULT_COLORSCHEME)

			-- You can configure highlights by doing something like:
			-- vim.cmd.hi 'Comment gui=none'

			-- Enable transparent background for all themes
			vim.g.transparent_enabled = true

			vim.keymap.set('n', '<leader>rt', '<cmd>TransparentToggle<CR>', { desc = 'T[R]ansparent [T]oggle'})
		end
	},

	{ 'numToStr/Comment.nvim', opts = {} },

	{ -- Git command utilities
		'tpope/vim-fugitive',
		config = function ()
			-- Git command keymaps
			vim.keymap.set('n', '<leader>fn', '<cmd>Git difftool<CR><C-w>w', { desc = '[F]ocus Cha[N]ges (Difftool)'})
			vim.keymap.set('n', '<leader>fm', '<cmd>Git mergetool<CR><C-w>w', { desc = '[F]ocus [M]ergetool'})
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
			-- Git diff keymaps, todo: set more keymaps
			vim.keymap.set('n', '<leader>vv', '<cmd>Gitsigns preview_hunk_inline<CR>', { desc = '[V] Pre[V]iew hunk inline'})
			vim.keymap.set('n', '<leader>vn', '<cmd>Gitsigns next_hunk<CR>', { desc = '[V] [N]ext hunk'})
			vim.keymap.set('n', '<leader>vp', '<cmd>Gitsigns prev_hunk<CR>', { desc = '[V] [P]revious hunk'})
			vim.keymap.set('n', '<leader>vr', '<cmd>Gitsigns reset_hunk<CR>', { desc = '[V] [R]eset hunk'})

			vim.keymap.set('n', '<leader>fd', '<cmd>Gitsigns diffthis<CR>', { desc = '[F]ocus this [D]iff'})

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
			{ 'nvim-tree/nvim-web-devicons' },
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

				defaults = {
				  mappings = {
					i = {
						-- ['<C-enter>'] = 'to_fuzzy_refine',
						['<C-k>'] = 'preview_scrolling_up',
						['<C-j>'] = 'preview_scrolling_down',
					},
					n = {
						-- ['kj'] = 'close',
						['<C-k>'] = 'preview_scrolling_up',
						['<C-j>'] = 'preview_scrolling_down',
					},
			  },
				},
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
			vim.keymap.set('n', '<leader>;', builtin.find_files, { desc = '[ ] Find files' })
			-- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

			vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Search existing buffers' })
			vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
			vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
			vim.keymap.set('n', '<leader>sl', builtin.builtin, { desc = '[S]earch Se[L]ect Telescope' })
			vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
			vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
			vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
			vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
			vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set('n', '<leader>sc', builtin.colorscheme, { desc = '[S]earch [C]olorschemes' })
			vim.keymap.set('n', '<leader>sf', '<cmd>Telescope grep_string search=<CR>', { desc = '[S]earch [F]uzzily in current dir' })

			vim.keymap.set('n', '<leader>ss', builtin.git_status, { desc = 'Git [S]earch [S]tatus' })
			vim.keymap.set('n', '<leader>sb', builtin.git_bcommits, { desc = 'Git [S]earch [B]uffer Commits' })
			vim.keymap.set('n', '<leader>sm', builtin.git_commits, { desc = 'Git [S]earch Co[M]mits' })
			vim.keymap.set('n', '<leader>sn', builtin.git_branches, { desc = 'Git [S]earch Bra[N]ches' })

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
			vim.keymap.set('n', '<leader>sv', function()
				builtin.find_files { cwd = vim.fn.stdpath 'config' }
			end, { desc = '[S]earch Neo[V]im files' })
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
				clangd = {},
				rust_analyzer = {},

				lua_ls = {
					-- cmd = {...},
					-- filetypes = { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							-- completion = {
							-- 	callSnippet = 'Replace',
							-- },
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
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

			-- Needed to resolve 'undefined global vim' warning
			-- For some reason, doesn't work with the above servers table
			vim.lsp.config('lua_ls', {
				settings = {
					Lua = {
						diagnostics = {
							globals = { 'vim' },
							disable = { 'missing-fields' },
						},
					},
				},
			})

			require('lspconfig').gdscript.setup {}
		end,
	},

	{ -- Debug adapter
	  'mfussenegger/nvim-dap',
	  config = function()
		local dap = require('dap')
		dap.adapters.godot = {
		  type = 'server',
		  host = '127.0.0.1',
		  port = 6006,
		}
		dap.configurations.gdscript = {
		  {
			type = 'godot',
			request = 'launch',
			name = 'Launch scene',
			project = '${workspaceFolder}',
		  },
		}
		vim.keymap.set('n', '<leader>dd', '<cmd>DapToggleBreakpoint<cr>', { desc = '[D]ap Toggle breakpoint' })
		vim.keymap.set('n', '<leader>dc', '<cmd>DapContinue<cr>', { desc = '[D]ap [C]ontinue' })
		vim.keymap.set('n', '<leader>do', '<cmd>DapStepOver<cr>', { desc = '[D]ap Step [O]ver' })
		vim.keymap.set('n', '<leader>di', '<cmd>DapStepInto<cr>', { desc = '[D]ap Step [I]nto' })
		vim.keymap.set('n', '<leader>du', '<cmd>DapStepOut<cr>', { desc = '[D]ap Step o[U]t' })
	  end
	},

	{
		'rcarriga/nvim-dap-ui',
		dependencies = {
			'mfussenegger/nvim-dap',
			'nvim-neotest/nvim-nio'
		},
		config = function()
		    require('dapui').setup()
			local dap = require('dap')
			dap.listeners.before.attach.dapui_config = function()
			  require('dapui').open()
			end
			dap.listeners.before.launch.dapui_config = function()
			  require('dapui').open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
			  require('dapui').close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
			  require('dapui').close()
			end

			vim.keymap.set('n', '<leader>dt', function ()
				require('dapui').toggle()
			end, { desc = '[D]ap [T]oggle Dap UI' })
		end
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
				completion = {},

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
					['<C-y>'] = cmp.mapping.confirm { select = true },

					-- If you prefer more traditional completion keymaps
					-- ['<CR>'] = cmp.mapping.confirm { select = true },
					-- ['<Tab>'] = cmp.mapping.select_next_item(),
					-- ['<S-Tab>'] = cmp.mapping.select_prev_item(),

					-- Manually trigger a completion from nvim-cmp.
					['<C-Space>'] = cmp.mapping.complete {},
				},
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					-- { name = 'buffer' },
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

		  require('mini.starter').setup {
			header = vim.fn.getcwd(),
		    autoopen = true,
			footer = "",
		  }
		  -- Simple and easy statusline.
		  --  You could remove this setup call if you don't like it,
		  --  and try some other statusline plugin
		  local statusline = require 'mini.statusline'
		  statusline.setup { use_icons = true }

		  -- You can configure sections in the statusline by overriding their
		  -- default behavior. For example, here we set the section for
		  -- cursor location to LINE:COLUMN
		  ---@diagnostic disable-next-line: duplicate-set-field
		  statusline.section_location = function()
			return '%2l:%-2v'
		  end
		end,
	},

	{ -- Highlight, edit, and navigate code
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	opts = {
		ensure_installed = {
			'bash',
			'c',
			'diff',
			'html',
			'lua',
			'luadoc',
			'markdown',
			'vim',
			'vimdoc',
			'rust',
			'python',
		},
		auto_install = true,
		highlight = {
			enable = true,
			-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
			--  If you are experiencing weird indenting issues, add the language to
			--  the list of additional_vim_regex_highlighting and disabled languages for indent.
			additional_vim_regex_highlighting = { 'ruby' },
		},
		indent = { enable = true, disable = { 'ruby' } },
	},
	config = function(_, opts)
		require('nvim-treesitter.install').compilers = { 'clang', 'gcc', 'zig' }
		-- Prefer git instead of curl in order to improve connectivity in some environments
		require('nvim-treesitter.install').prefer_git = true
		---@diagnostic disable-next-line: missing-fields
		require('nvim-treesitter.configs').setup(opts)

		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		end,
	},

	{ -- Highlight other uses of the word under the cursor using either LSP, Tree-sitter, or regex matching
		'RRethy/vim-illuminate',
		config = function ()
			require('illuminate').configure({
				-- providers: provider used to get references in the buffer, ordered by priority
				providers = {
					'lsp',
					'treesitter',
					'regex',
				},
				-- delay: delay in milliseconds
				delay = 100,
				-- filetype_overrides: filetype specific overrides.
				-- The keys are strings to represent the filetype while the values are tables that
				-- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
				filetype_overrides = {},
				-- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
				filetypes_denylist = {
					'dirbuf',
					'dirvish',
					'fugitive',
				},
				-- filetypes_allowlist: filetypes to illuminate, this is overridden by filetypes_denylist
				-- You must set filetypes_denylist = {} to override the defaults to allow filetypes_allowlist to take effect
				filetypes_allowlist = {},
				-- modes_denylist: modes to not illuminate, this overrides modes_allowlist
				-- See `:help mode()` for possible values
				modes_denylist = {},
				-- modes_allowlist: modes to illuminate, this is overridden by modes_denylist
				-- See `:help mode()` for possible values
				modes_allowlist = {},
				-- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
				-- Only applies to the 'regex' provider
				-- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
				providers_regex_syntax_denylist = {},
				-- providers_regex_syntax_allowlist: syntax to illuminate, this is overridden by providers_regex_syntax_denylist
				-- Only applies to the 'regex' provider
				-- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
				providers_regex_syntax_allowlist = {},
				-- under_cursor: whether or not to illuminate under the cursor
				under_cursor = true,
				-- large_file_cutoff: number of lines at which to use large_file_config
				-- The `under_cursor` option is disabled when this cutoff is hit
				large_file_cutoff = nil,
				-- large_file_config: config to use for large files (based on large_file_cutoff).
				-- Supports the same keys passed to .configure
				-- If nil, vim-illuminate will be disabled for large files.
				large_file_overrides = nil,
				-- min_count_to_highlight: minimum number of matches required to perform highlighting
				min_count_to_highlight = 1,
				-- should_enable: a callback that overrides all other settings to
				-- enable/disable illumination. This will be called a lot so don't do
				-- anything expensive in it.
				should_enable = function(bufnr) return true end,
				-- case_insensitive_regex: sets regex case sensitivity
				case_insensitive_regex = false,
			})
		end
	},

	{ -- Yazi
		'mikavilpas/yazi.nvim',
		event = 'VeryLazy',
		keys = {
			{
				'<leader>y',
				mode = { 'n', 'v' },
				'<cmd>Yazi<cr>',
				desc = 'Open yazi (current file)',
			},
			{
				'<leader>Y',
				'<cmd>Yazi cwd<cr>',
				desc = 'Open yazi (current working dir)',
			},
		},
		opts = {
			open_for_directories = false,
			keymaps = {
				show_help = '<f1>',
			},
		},
	},

	{ -- LazyGit
		'kdheepak/lazygit.nvim',
		lazy = true,
		cmd = {
			'LazyGit',
			'LazyGitConfig',
			'LazyGitCurrentFile',
			'LazyGitFilter',
			'LazyGitFilterCurrentFile',
		},
		-- optional for floating window border decoration
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' }
		}
	},

	{ -- Harpoon
		'ThePrimeagen/harpoon',
		branch = 'harpoon2',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
		},
		config = function ()
			local harpoon = require('harpoon')
			harpoon:setup()

			vim.keymap.set('n', '<C-e>', function() harpoon:list():add() end)
			vim.keymap.set('n', '<C-r>', function() harpoon:list():remove() end)
			vim.keymap.set('n', '<leader>H', function() harpoon:list():clear() end)

			vim.keymap.set('n', '<leader>h', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

			vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end)
			vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end)
			vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end)
			vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end)
			vim.keymap.set('n', '<leader>5', function() harpoon:list():select(5) end)
			vim.keymap.set('n', '<leader>6', function() harpoon:list():select(6) end)
			vim.keymap.set('n', '<leader>7', function() harpoon:list():select(7) end)
			vim.keymap.set('n', '<leader>8', function() harpoon:list():select(8) end)
			vim.keymap.set('n', '<leader>9', function() harpoon:list():select(9) end)

			-- basic telescope configuration
			-- local conf = require('telescope.config').values
			-- local function toggle_telescope(harpoon_files)
			-- 	local file_paths = {}
			-- 	for _, item in ipairs(harpoon_files.items) do
			-- 		table.insert(file_paths, item.value)
			-- 	end
			--
			-- 	require('telescope.pickers').new({}, {
			-- 		prompt_title = 'Harpoon',
			-- 		finder = require('telescope.finders').new_table({
			-- 			results = file_paths,
			-- 		}),
			-- 		previewer = conf.file_previewer({}),
			-- 		sorter = conf.generic_sorter({}),
			-- 	}):find()
			-- end
			--
			-- vim.keymap.set('n', '<leader>h', function() toggle_telescope(harpoon:list()) end,
			-- 	{ desc = 'Open [H]arpoon window' })
		end
	},

	{ -- Scrollbar
		'petertriho/nvim-scrollbar',
		config = function ()
			require('scrollbar').setup({
				handle = {
					blend = 75, -- Opacity
				}
			})
		end
	},
}
