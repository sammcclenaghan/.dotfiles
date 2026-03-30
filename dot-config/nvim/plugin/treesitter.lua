vim.api.nvim_create_autocmd("FileType", { callback = function() pcall(vim.treesitter.start) end })
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99

require('nvim-treesitter-textobjects').setup({
  select = { lookahead = true },
  move = { set_jumps = true },
})

local ts_select = require('nvim-treesitter-textobjects.select')
local ts_move = require('nvim-treesitter-textobjects.move')

for _, mapping in ipairs({
  { 'af', '@function.outer' },
  { 'if', '@function.inner' },
  { 'ac', '@class.outer' },
  { 'ic', '@class.inner' },
  { 'aa', '@parameter.outer' },
  { 'ia', '@parameter.inner' },
}) do
  vim.keymap.set({ 'x', 'o' }, mapping[1], function()
    ts_select.select_textobject(mapping[2], 'textobjects')
  end)
end

vim.keymap.set({ 'n', 'x', 'o' }, ']f', function() ts_move.goto_next_start('@function.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, '[f', function() ts_move.goto_previous_start('@function.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, ']c', function() ts_move.goto_next_start('@class.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, '[c', function() ts_move.goto_previous_start('@class.outer', 'textobjects') end)
