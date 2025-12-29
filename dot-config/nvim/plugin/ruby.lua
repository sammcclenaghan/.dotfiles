-- Rails docs lookup
vim.keymap.set('n', '<leader>rd', function()
  local word = vim.fn.expand('<cword>')
  vim.ui.open('https://api.rubyonrails.org/?q=' .. word)
end, { desc = 'Rails API docs' })
