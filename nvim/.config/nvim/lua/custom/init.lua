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

-- When wrapping is toggled on (<leader>tw): visual-only wrap that never splits
-- words; continuation lines keep the indent (breakindent, set above by
-- kickstart) and start with a marker so they are easy to spot.
vim.o.linebreak = true
vim.opt.showbreak = '↳ '

-- Minimal number of screen lines to keep above and below the cursor (kickstart uses 10).
vim.o.scrolloff = 15

-- Set highlight on search (cleared on <Esc>, mapped by kickstart)
vim.o.hlsearch = true

-- disable folding on startup
vim.o.foldenable = false
vim.o.foldlevel = 20

-- Several language servers only attach to specialised filetypes that nothing
-- produces by default (ansiblels -> yaml.ansible, docker_compose_language_service
-- -> yaml.docker-compose, yamlls dialects, tofu_ls -> opentofu). Teach Neovim
-- to detect them so those servers actually start.
vim.filetype.add {
  extension = {
    tf = 'terraform',
    tfvars = 'terraform', -- Also include .tfvars files for consistency
    tofu = 'opentofu',
    tofuvars = 'opentofu-vars',
  },
  filename = {
    ['docker-compose.yml'] = 'yaml.docker-compose',
    ['docker-compose.yaml'] = 'yaml.docker-compose',
    ['compose.yml'] = 'yaml.docker-compose',
    ['compose.yaml'] = 'yaml.docker-compose',
    ['.gitlab-ci.yml'] = 'yaml.gitlab',
    ['.gitlab-ci.yaml'] = 'yaml.gitlab',
  },
  pattern = {
    -- ansible
    ['.*/playbooks/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/roles/.*/tasks/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/roles/.*/handlers/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/group_vars/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/host_vars/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/molecule/.*%.ya?ml'] = 'yaml.ansible',
    ['.*ansible.*/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/playbook%.ya?ml'] = 'yaml.ansible',
    ['.*/site%.ya?ml'] = 'yaml.ansible',
    -- docker compose variants like docker-compose.override.yml
    ['.*/docker%-compose%..*%.ya?ml'] = 'yaml.docker-compose',
    ['.*/compose%..*%.ya?ml'] = 'yaml.docker-compose',
    -- gitlab CI includes like .gitlab/ci/*.yml
    ['.*/%.gitlab/.*%.ya?ml'] = 'yaml.gitlab',
    -- helm values files inside a chart
    ['.*/charts?/.*/values.*%.ya?ml'] = 'yaml.helm-values',
    ['.*/helm/.*/values.*%.ya?ml'] = 'yaml.helm-values',
  },
}

-- The specialised filetypes have no treesitter parsers of their own — reuse
-- the base ones so highlighting keeps working.
vim.treesitter.language.register('yaml', { 'yaml.ansible', 'yaml.docker-compose', 'yaml.gitlab', 'yaml.helm-values' })
vim.treesitter.language.register('terraform', { 'opentofu', 'opentofu-vars' })

-- [[ Keymaps ]]

-- Togle inline LSP diagnostics
vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true, desc = '[T]oggle [D]iagnostics' })

-- Open the diagnostic float; press again (or after [d/]d auto-float) to focus
-- it, so the text can be yanked. q closes it. cursor scope matches the
-- auto-float from jump.on_jump in init.lua, so the second press reuses it.
vim.keymap.set('n', '<leader>e', function()
  vim.diagnostic.open_float { scope = 'cursor' }
end, { desc = 'Show diagnostic [E]rror float (again to focus)' })

-- Split Tmux panes
vim.keymap.set('n', '<leader>sth', '<cmd>silent !tmux split-window -h<CR>', { desc = '[S]plit [T]mux pane [H]orizontally' })
vim.keymap.set('n', '<leader>stv', '<cmd>silent !tmux split-window -v<CR>', { desc = '[S]plit [T]mux pane [V]ertically' })

-- Better paste behavior
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste without yanking' })

-- Delete without yanking
-- vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d', { desc = 'Delete without yanking' })

-- Splitting (sv, not sw: <leader>sw is telescope's [S]earch current [W]ord)
vim.keymap.set('n', '<leader>svh', ':vsplit<CR>', { desc = '[S]plit [V]im [H]orizontally' })
vim.keymap.set('n', '<leader>svv', ':split<CR>', { desc = '[S]plit [V]im [V]ertically' })

-- Toggle visual line wrapping (window-local; see linebreak/showbreak above)
vim.keymap.set('n', '<leader>tw', function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = '[T]oggle [W]rapping' })

-- Move lines up/down
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Better indenting in visual mode
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Markdown formatting: <leader>f (conform + rumdl) puts one sentence per line;
-- <leader>F instead wraps paragraphs at 100 columns. gq/gw wrap just a few
-- lines at the same width.
-- NOTE: gq does not understand code blocks or tables — avoid running it over them.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('MarkdownTextwidth', { clear = true }),
  pattern = 'markdown',
  callback = function(ev)
    vim.bo[ev.buf].textwidth = 100
    -- Never auto-wrap while typing: the runtime markdown ftplugin adds 't' (text)
    -- and 'c' (comments = list items/quotes here). 'q' stays, so gq/gw still work.
    vim.opt_local.formatoptions:remove { 't', 'c' }
    vim.keymap.set({ 'n', 'v' }, '<leader>F', function()
      require('conform').format { async = true, formatters = { 'rumdl_wrap' } }
    end, { buffer = ev.buf, desc = '[F]ormat markdown wrapped to line length' })
  end,
})

-- In the fugitive status buffer, <CR> on a STAGED file opens the read-only
-- index object (fugitive:///...//0/...) by design. Override: file lines open
-- the work-tree file; anything else replays fugitive's original mapping.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('FugitiveWorktreeCR', { clear = true }),
  pattern = 'fugitive',
  callback = function(ev)
    local orig = vim.fn.maparg('<CR>', 'n', false, true)
    vim.keymap.set('n', '<CR>', function()
      local path = vim.api.nvim_get_current_line():match '^[MADRCU?! ][MADRCU?! ]?%s+(.+)$'
      local file = path and vim.fn.FugitiveFind(path) or ''
      if path and vim.fn.filereadable(file) == 1 then
        -- Open where fugitive's native <CR> would: a window already showing
        -- the file, else the window :G was run from — not the status pane.
        local buf = vim.fn.bufnr(file)
        local target
        if buf ~= -1 then
          for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_buf(w) == buf then
              target = w
              break
            end
          end
        end
        if target then
          vim.api.nvim_set_current_win(target)
        else
          vim.cmd.wincmd 'p'
        end
        vim.cmd.edit(vim.fn.fnameescape(file))
      elseif orig and orig.rhs then
        local keys = orig.rhs:gsub('<SID>', '<SNR>' .. orig.sid .. '_')
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), 'n', false)
      end
    end, { buffer = ev.buf, desc = 'Open work-tree file (fugitive object on non-file lines)' })
  end,
})

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

-- Pick up files changed outside nvim (git, agents, other editors): autoread
-- only acts when a timestamp check runs, so trigger checktime ourselves.
-- FocusGained needs `focus-events on` in tmux to fire inside tmux.
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'TermLeave' }, {
  group = vim.api.nvim_create_augroup('AutoreadCheck', { clear = true }),
  callback = function()
    if vim.bo.buftype == '' then
      vim.cmd 'checktime'
    end
  end,
  desc = 'Check for external file changes',
})
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = vim.api.nvim_create_augroup('AutoreadNotify', { clear = true }),
  callback = function()
    vim.notify('File changed on disk, buffer reloaded', vim.log.levels.INFO)
  end,
})
