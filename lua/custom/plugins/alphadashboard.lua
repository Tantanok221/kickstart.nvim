return {
  'goolord/alpha-nvim',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'
    dashboard.section.buttons.val = {
      dashboard.button('e', '  > New file', ':ene <BAR> startinsert <CR>'),
      dashboard.button('s', '  > Search file', ':Telescope find_files<CR>'),
      dashboard.button('r', '  > Recent', ':Telescope oldfiles<CR>'),
      dashboard.button('g', '󰊢  > LazyGit', ':LazyGit <CR>'),
      dashboard.button('<leader>cc', '  > Claude Code', ':ClaudeCode <CR>'),
      dashboard.button('c', '  > Config', ':Telescope find_files cwd=~/.config/nvim/ <CR>'),
      dashboard.button('q', '  > Quit NVIM', ':qa<CR>'),
    }
    alpha.setup(dashboard.opts)
  end,
}
