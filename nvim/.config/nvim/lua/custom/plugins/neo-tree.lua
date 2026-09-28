-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-neo-tree/neo-tree.nvim',
}

require('neo-tree').setup {
  source_selector = {
    statusline = true,
  },
  filesystem = {
    window = {
      mappings = {
        ['\\'] = 'close_window',
      },
    },
    filtered_items = {
      visible = true,
      hide_gitignored = false,
      hide_hidden = false,
      hide_dotfiles = false,
    },
    follow_current_file = {
      enabled = true,
    },
    hijack_netrw_behavior = 'open_current',
  },
  event_handlers = {
    {
      event = 'file_open_requested',
      handler = function()
        -- auto close
        require('neo-tree.command').execute { action = 'close' }
      end,
    },
  },
  popup_border_style = 'rounded',
  close_if_last_window = true,
}

vim.keymap.set('n', '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' })
