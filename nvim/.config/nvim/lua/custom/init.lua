-- [[ My customizations on top of kickstart.nvim ]]
--
-- Everything additive lives here (plus plugin specs in `lua/custom/plugins/`,
-- auto-imported by lazy.nvim). init.lua stays close to upstream kickstart:
-- its only custom lines are `require 'custom'`, `{ import = 'custom.plugins' }`,
-- and in-place edits of kickstart plugin specs marked with `-- CUSTOM:`.

-- [[ PATH ]]

-- GUI-launched nvim gets launchd's minimal PATH, not the interactive-zsh one, so
-- tools like node/pnpm (Volta shims) and tofu/rg (Homebrew) go missing along with
-- the git hooks and formatters that call them. Prepend the static dirs once.
for _, dir in ipairs { '/opt/homebrew/bin', vim.fn.expand '~/.volta/bin' } do
  if vim.fn.isdirectory(dir) == 1 and not string.find(vim.env.PATH or '', dir .. ':', 1, true) then
    vim.env.PATH = dir .. ':' .. vim.env.PATH
  end
end

-- [[ Options ]]

-- size of a hard tabstop (ts).
vim.o.tabstop = 2

-- size of an indentation (sw).
vim.o.shiftwidth = 2

-- always uses spaces instead of tab characters (et).
vim.o.expandtab = true

-- number of spaces a <Tab> counts for. When 0, feature is off (sts).
vim.o.softtabstop = 2

-- Do not wrap text longer than screean size
vim.o.wrap = false

-- Minimal number of screen lines to keep above and below the cursor (kickstart uses 10).
vim.o.scrolloff = 15

-- Set highlight on search (cleared on <Esc>, mapped by kickstart)
vim.o.hlsearch = true

-- disable folding on startup
vim.o.foldenable = false
vim.o.foldlevel = 20

vim.filetype.add {
  extension = {
    tf = 'terraform',
    tfvars = 'terraform', -- Also include .tfvars files for consistency
  },
}

-- [[ Keymaps ]]

-- Togle inline LSP diagnostics
vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true, desc = '[T]oggle [D]iagnostics' })

-- Split Tmux panes
vim.keymap.set('n', '<leader>sth', '<cmd>silent !tmux split-window -h<CR>', { desc = '[S]plit [T]mux pane [H]orizontally' })
vim.keymap.set('n', '<leader>stv', '<cmd>silent !tmux split-window -v<CR>', { desc = '[S]plit [T]mux pane [V]ertically' })

-- Better paste behavior
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste without yanking' })

-- Delete without yanking
-- vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d', { desc = 'Delete without yanking' })

-- Splitting
vim.keymap.set('n', '<leader>sh', ':vsplit<CR>', { desc = '[S]plit window [h]orizontally' })
vim.keymap.set('n', '<leader>sv', ':split<CR>', { desc = '[S]plit window [v]ertically' })

-- Move lines up/down
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Better indenting in visual mode
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- [[ Autocommands ]]

-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('last-position', { clear = true }),
  callback = function(args)
    local valid_line = vim.fn.line [['"]] >= 1 and vim.fn.line [['"]] < vim.fn.line '$'
    local not_commit = vim.b[args.buf].filetype ~= 'commit'

    if valid_line and not_commit then
      vim.cmd [[normal! g`"]]
    end
  end,
})

-- Resize windows on the host window size change
vim.api.nvim_create_autocmd('VimResized', {
  group = vim.api.nvim_create_augroup('WinResize', { clear = true }),
  pattern = '*',
  command = 'wincmd =',
  desc = 'Automatically resize windows when the host window size changes.',
})
