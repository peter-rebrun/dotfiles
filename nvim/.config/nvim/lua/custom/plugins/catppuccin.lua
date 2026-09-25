-- Colorscheme (replaces kickstart's tokyonight)
vim.pack.add { 'https://github.com/catppuccin/nvim' }

require('catppuccin').setup {
  integrations = {
    cmp = true,
    gitsigns = true,
    neotree = true,
    treesitter = true,
    notify = false,
    mini = {
      enabled = true,
      indentscope_color = '',
    },
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
}

-- setup must be called before loading
vim.cmd.colorscheme 'catppuccin-macchiato'
