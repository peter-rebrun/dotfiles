return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = false,
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
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
    -- completion = {
    --   nvim_cmp = false,
    --   blink = true,
    --   min_chars = 2,
    --   match_case = false,
    --   create_new = false,
    -- },

    -- mappings = {
    --   -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
    --   ['gf'] = {
    --     action = function()
    --       return require('obsidian').util.gf_passthrough()
    --     end,
    --     opts = { noremap = false, expr = true, buffer = true },
    --   },
    --   -- Toggle check-boxes.
    --   ['<leader>ch'] = {
    --     action = function()
    --       return require('obsidian').util.toggle_checkbox()
    --     end,
    --     opts = { buffer = true },
    --   },
    --   -- Smart action depending on context, either follow link or toggle checkbox.
    --   ['<cr>'] = {
    --     action = function()
    --       return require('obsidian').util.smart_action()
    --     end,
    --     opts = { buffer = true, expr = true },
    --   },
    -- },

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
    --   -- You can always override this per image by passing a full path to the command instead of just a filename.
    --   img_folder = '_resources', -- This is the default
    -- },
  },

  vim.keymap.set('n', '<leader>so', ':Obsidian search<cr>', { desc = '[S]earch [O]bsidian Vault' }),
  vim.keymap.set('n', '<leader>os', ':Obsidian search<cr>', { desc = '[O]bsidian [S]earch Vault' }),
  vim.keymap.set('n', '<leader>od', ':Obsidian today<cr>', { desc = '[O]bsidian [D]aily Note' }),
  vim.keymap.set('n', '<leader>ot', ':Obsidian toc<cr>', { desc = '[O]bsidian [T]able of context' }),
  vim.keymap.set('n', '<leader>on', ':Obsidian new_from_template<cr>', { desc = '[O]bsidian [N]ew Note' }),
}
