return {
  'catppuccin/nvim',
  priority = 1000,
  config = function()
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
  end,
}
