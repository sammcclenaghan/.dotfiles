vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.swapfile = false
vim.o.signcolumn = 'yes'
vim.o.cursorline = true
vim.o.scrolloff = 10

vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.pack.add({
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate'
  },
  { src = "https://github.com/echasnovski/mini.pick" },
  { src = "https://github.com/stevearc/oil.nvim" },
})

vim.api.nvim_create_autocmd("FileType", { callback = function() pcall(vim.treesitter.start) end })
vim.opt.foldmethod, vim.opt.foldexpr = "expr", "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

require('mini.pick').setup()
vim.keymap.set('n', '<leader>ff', MiniPick.builtin.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', MiniPick.builtin.grep_live, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', MiniPick.builtin.buffers, { desc = 'Buffers' })

require('oil').setup()
vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory' })

vim.lsp.enable({ "lua_ls", "ruby_lsp", "herb_ls" })

vim.diagnostic.config({
  virtual_text = true,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

vim.cmd("set completeopt+=noselect")

vim.cmd("colorscheme gruvbox")

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
