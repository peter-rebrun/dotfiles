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

-- shellcheck: bash/sh buffers already get shellcheck diagnostics via
-- bash-language-server, which runs the (Homebrew-installed) binary itself —
-- adding it here too would duplicate them. zsh is not attached by bashls and
-- shellcheck has no zsh dialect, so lint zsh in bash mode as a best effort.
local shellcheck_zsh = vim.deepcopy(lint.linters.shellcheck)
table.insert(shellcheck_zsh.args, 1, '--shell=bash')
lint.linters.shellcheck_zsh = shellcheck_zsh

lint.linters_by_ft = {
  markdown = { 'markdownlint' },
  -- markdown = { 'vale' },
  python = { 'ruff' },
  terraform = { 'tflint' },
  -- 'zsh' runs `zsh --no-exec`: the real zsh parser, syntax errors only.
  -- shellcheck_zsh adds correctness smells but can false-positive on zsh syntax.
  zsh = { 'zsh', 'shellcheck_zsh' },
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
  -- not mason packages: zsh is the system binary, shellcheck_zsh is our
  -- derived linter (the shellcheck binary comes from Homebrew)
  ignore_install = { 'zsh', 'shellcheck_zsh' },
  -- Optional: list of linters to ensure are installed immediately upon startup.
  -- These names must match the mason registry names.
  ensure_installed = {
    'ruff',
    'mypy',
    'tflint',
    'oxlint',
    'markdownlint',
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
