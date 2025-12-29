vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false

vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

vim.pack.add({
	{src = "https://github.com/ellisonleao/gruvbox.nvim"},
	{ 
		src = 'https://github.com/nvim-treesitter/nvim-treesitter', 
		branch = 'master',
		build = ':TSUpdate' 
	},
})

vim.api.nvim_create_autocmd("FileType", { callback = function() pcall(vim.treesitter.start) end })
vim.opt.foldmethod, vim.opt.foldexpr = "expr", "v:lua.vim.treesitter.foldexpr()"

-- C) Native Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

vim.lsp.enable({"lua_ls"})

vim.cmd("colorscheme gruvbox")
