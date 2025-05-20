return {
  {
    'linrongbin16/gitlinker.nvim',
    cmd = 'GitLink',
    opts = {},
    keys = {
      { '<leader>gy', '<cmd>GitLink current_branch<cr>', mode = { 'n', 'v' }, desc = 'Git link current brach' },
      { '<leader>gY', '<cmd>GitLink default_branch<cr>', mode = { 'n', 'v' }, desc = 'Git link default branch' },
    },
  },
}
