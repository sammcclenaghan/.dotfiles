-- Toggle scratch buffer (right-side split)
local scratch_buf = nil

vim.keymap.set('n', '<leader>s', function()
  if scratch_buf and vim.api.nvim_buf_is_valid(scratch_buf) then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == scratch_buf then
        vim.api.nvim_win_close(win, false)
        return
      end
    end
    vim.cmd('botright vsplit')
    vim.api.nvim_win_set_buf(0, scratch_buf)
  else
    vim.cmd('botright vsplit')
    scratch_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, scratch_buf)
    vim.bo[scratch_buf].filetype = 'markdown'
  end
  vim.cmd('vertical resize 60')
end, { desc = 'Toggle scratch' })
