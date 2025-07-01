vim.keymap.set('n', '<leader>cc', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })
vim.keymap.set('n', '\\', ':Telescope file_browser<CR>')
vim.keymap.set('n', '<leader>H', ':Alpha<CR>', { desc = 'Go Back to Dashboard' })
vim.keymap.set('n', '<leader>Q', ':wqa<CR>', { desc = 'Quit Neovim' })

-- Autocompletion keymaps (blink.cmp)
vim.keymap.set('i', '<Tab>', function()
  if require('blink.cmp').is_visible() then
    return require('blink.cmp').select_next()
  else
    return '<Tab>'
  end
end, { expr = true, desc = 'Next completion item' })

vim.keymap.set('i', '<S-Tab>', function()
  if require('blink.cmp').is_visible() then
    return require('blink.cmp').select_prev()
  else
    return '<S-Tab>'
  end
end, { expr = true, desc = 'Previous completion item' })

vim.keymap.set('i', '<CR>', function()
  if require('blink.cmp').is_visible() then
    return require('blink.cmp').accept()
  else
    return '<CR>'
  end
end, { expr = true, desc = 'Accept completion' })
