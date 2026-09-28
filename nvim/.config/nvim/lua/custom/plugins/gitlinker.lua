vim.pack.add { 'https://github.com/linrongbin16/gitlinker.nvim' }

require('gitlinker').setup {}

vim.keymap.set({ 'n', 'v' }, '<leader>gy', '<cmd>GitLink current_branch<cr>', { desc = 'Git link current brach' })
vim.keymap.set({ 'n', 'v' }, '<leader>gY', '<cmd>GitLink default_branch<cr>', { desc = 'Git link default branch' })
