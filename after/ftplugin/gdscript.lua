local is_win = vim.fn.has 'win32' == 1

if is_win then
	vim.lsp.start {
		name = 'Godot',
		cmd = { 'ncat', '127.0.0.1', '6005' },
	}
else
	vim.lsp.start {
		name = 'Godot',
		cmd = vim.lsp.rpc.connect('127.0.0.1', 6005),
	}
end
