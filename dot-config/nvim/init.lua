vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'

vim.opt.signcolumn = 'yes'

vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.breakindent = true
vim.opt.wrap = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 80

vim.diagnostic.config({
  virtual_text = true, 
})

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.cmd.colorscheme('gruvbox')

vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" }, { confirm = false })

require("nvim-treesitter.install").update("all")
require("nvim-treesitter.configs").setup({
  auto_install = true, -- autoinstall languages that are not installed yet
})


vim.pack.add({
  { src = 'https://github.com/ellisonleao/gruvbox.nvim' },
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    data = {
      run = function(_) vim.cmd 'TSUpdate' end,
    },
  },
  { src = 'https://github.com/echasnovski/mini.pick' },
  { src = 'https://github.com/echasnovski/mini.surround' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
  { src = 'https://github.com/folke/which-key.nvim' },
})

require('mini.pick').setup()
vim.keymap.set('n', '<leader>ff', MiniPick.builtin.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', MiniPick.builtin.grep_live, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', MiniPick.builtin.buffers, { desc = 'Buffers' })

require('which-key').setup()
require('mini.surround').setup()

require('oil').setup()
vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory' })


vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})
