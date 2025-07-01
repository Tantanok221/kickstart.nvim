vim.keymap.set('n', '<leader>cc', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })
vim.keymap.set('n', '\\', ':Telescope file_browser<CR>')
vim.keymap.set('n', '<leader>H', ':Alpha<CR>', { desc = 'Go Back to Dashboard' })
vim.keymap.set('n', '<leader>Q', ':wqa<CR>', { desc = 'Quit Neovim' })

-- File operations
vim.keymap.set('n', '<leader>fb', ':Telescope file_browser<CR>', { desc = '[F]ile [B]rowser' })

-- Split windows
vim.keymap.set('n', '<leader>vv', ':vsplit<CR>', { desc = '[V]ertical split' })
vim.keymap.set('n', '<leader>vh', ':split<CR>', { desc = '[V]ertical [H]orizontal split' })

-- Navigate between splits with Ctrl + arrow keys
vim.keymap.set('n', '<C-Left>', '<C-w>h', { desc = 'Move focus to left split' })
vim.keymap.set('n', '<C-Right>', '<C-w>l', { desc = 'Move focus to right split' })
vim.keymap.set('n', '<C-Up>', '<C-w>k', { desc = 'Move focus to upper split' })
vim.keymap.set('n', '<C-Down>', '<C-w>j', { desc = 'Move focus to lower split' })

-- Format buffer (override the default <leader>f)
vim.keymap.set('n', '<leader>ff', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat [F]ile' })

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
