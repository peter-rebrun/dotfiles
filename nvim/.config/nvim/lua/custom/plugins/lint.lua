-- Linting (ruff/mypy for Python, oxlint for JS/TS/JSON)
-- mason itself is set up in init.lua's LSP section, which runs before this file.
vim.pack.add {
  'https://github.com/mfussenegger/nvim-lint',
  'https://github.com/rshkarin/mason-nvim-lint',
}

local lint = require 'lint'

local mypy = lint.linters.mypy
mypy.args = {
  '--show-column-numbers',
  '--show-error-end',
  '--hide-error-codes',
  '--hide-error-context',
  '--no-color-output',
  '--no-error-summary',
  '--no-pretty',
  '--python-executable .venv/bin/python',
}

lint.linters_by_ft = {
  -- markdown = { 'markdownlint' },
  -- markdown = { 'vale' },
  python = { 'ruff' },
  -- terraform = { 'tflint' },
  javascript = { 'oxlint' },
  typescript = { 'oxlint' },
  javascriptreact = { 'oxlint' },
  typescriptreact = { 'oxlint' },
  json = { 'oxlint' },
  jsonc = { 'oxlint' },
}

-- Installs the linters above via mason. Must be set up after mason and after
-- linters_by_ft so its auto-discovery sees the full list.
require('mason-nvim-lint').setup {
  automatic_installation = true,
  -- Optional: list of linters to ensure are installed immediately upon startup.
  -- These names must match the mason registry names.
  ensure_installed = {
    'ruff',
    'mypy',
    -- 'tflint',
    'oxlint',
  },
}

-- Create autocommand which carries out the actual linting
-- on the specified events.
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    -- Only run the linter in buffers that you can modify in order to
    -- avoid superfluous noise, notably within the handy LSP pop-ups that
    -- describe the hovered symbol using Markdown.
    if vim.bo.modifiable then
      lint.try_lint()
    end
  end,
})
