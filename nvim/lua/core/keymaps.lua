local map = vim.keymap.set

vim.g.mapleader = ' '

map('n', '<leader>e', function()
  if vim.bo.filetype == "NvimTree" then
    vim.cmd('wincmd p')
  else
    vim.cmd('NvimTreeFocus')
  end
end, { desc = 'Toggle focus NvimTree/code' })

map('n', '<leader>ff', ':Telescope find_files<CR>', { desc = 'Find files' })
map('n', '<leader>fg', ':Telescope live_grep<CR>', { desc = 'Live grep' })
map('n', '<leader>fb', ':Telescope buffers<CR>', { desc = 'Find buffers' })
map('n', '<leader>fh', ':Telescope help_tags<CR>', { desc = 'Help tags' })
map('n', '<leader>?', ':WhichKey<CR>', { desc = 'Which key' })
map('n', '<leader>s', ':w<CR>', { desc = 'Save' })
