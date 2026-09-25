-- Terragrunt language server. No plugin needed: nvim-lspconfig (loaded by
-- init.lua before this file) ships the terragrunt_ls config (ft=hcl, root
-- markers terragrunt.hcl/.git). The binary is built from
-- https://github.com/gruntwork-io/terragrunt-ls via `go install`, which drops
-- it in ~/go/bin — not on PATH, hence the explicit cmd.
-- NOT in the init.lua servers table because mason can't install it.
vim.lsp.config('terragrunt_ls', {
  cmd = { vim.fn.expand '~/go/bin/terragrunt-ls' },
  -- To see language server logs, uncomment:
  -- cmd_env = { TG_LS_LOG = vim.fn.expand '~/.local/state/nvim/terragrunt-ls.log' },
})
vim.lsp.enable 'terragrunt_ls'
