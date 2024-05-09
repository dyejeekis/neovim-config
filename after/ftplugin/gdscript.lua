local is_win = vim.fn.has 'win32' == 1

local port = os.getenv('GDScript_Port') or '6005'

local win_cmd = {'ncat', '127.0.0.1', port}
local unix_cmd = vim.lsp.rpc.connect('127.0.0.1', port)
local cmd = is_win and win_cmd or unix_cmd

local win_pipe = [[\\.\pipe\godot.pipe]]
local unix_pipe = '/tmp/godot.pipe'
local pipe = is_win and win_pipe or unix_pipe


vim.lsp.start({
  name = 'Godot',
  cmd = cmd,
  root_dir = vim.fs.dirname(vim.fs.find({ 'project.godot', '.git' }, { upward = true })[1]),
  on_attach = function(client, bufnr)
    vim.api.nvim_command('echo serverstart("' .. pipe .. '")')
  end
})
