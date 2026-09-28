-- Obsidian vault integration (~/WorkNotes/WorkNotes)
vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/obsidian-nvim/obsidian.nvim',
}

require('obsidian').setup {
  legacy_commands = false,
  ui = {
    enable = false,
  },
  workspaces = {
    {
      name = 'WorkNotes',
      path = '~/WorkNotes/WorkNotes',
    },
  },
  daily_notes = {
    folder = '03_Periodic/Daily',
    date_format = '%Y-%m-%d',
    template = 'Daily.md',
  },
  templates = {
    folder = '09_Templates',
    date_format = '%Y-%m-%d',
    time_format = '%H:%M',
    substitutions = {},
  },
  picker = {
    name = 'telescope.nvim',
    -- Optional, configure key mappings for the picker. These are the defaults.
    -- Not all pickers support all mappings.
    note_mappings = {
      -- Create a new note from your query.
      new = '<C-x>',
      -- Insert a link to the selected note.
      insert_link = '<C-l>',
    },
    tag_mappings = {
      -- Add tag(s) to current note.
      tag_note = '<C-x>',
      -- Insert a tag at the current location.
      insert_tag = '<C-l>',
    },
  },

  -- attachments = {
  --   -- The default folder to place images in via `:ObsidianPasteImg`.
  --   -- If this is a relative path it will be interpreted as relative to the vault root.
  --   img_folder = '_resources', -- This is the default
  -- },
}

vim.keymap.set('n', '<leader>so', ':Obsidian search<cr>', { desc = '[S]earch [O]bsidian Vault' })
vim.keymap.set('n', '<leader>os', ':Obsidian search<cr>', { desc = '[O]bsidian [S]earch Vault' })
vim.keymap.set('n', '<leader>od', ':Obsidian today<cr>', { desc = '[O]bsidian [D]aily Note' })
vim.keymap.set('n', '<leader>ot', ':Obsidian toc<cr>', { desc = '[O]bsidian [T]able of context' })
vim.keymap.set('n', '<leader>on', ':Obsidian new_from_template<cr>', { desc = '[O]bsidian [N]ew Note' })
