-- Swift / Xcode development: sourcekit-lsp + xcodebuild.nvim (build, run,
-- test, debug, coverage). swiftformat (conform) and swiftlint (nvim-lint) are
-- set up in init.lua and lint.lua.
--
-- For .xcodeproj/.xcworkspace apps, sourcekit-lsp needs a buildServer.json in
-- the project root (via the Homebrew xcode-build-server). Run :XcodebuildSetup
-- once per project to pick scheme/device and generate it; plain Swift packages
-- work without it.

-- sourcekit-lsp ships with Xcode (/usr/bin/sourcekit-lsp shim), so it's NOT in
-- the init.lua servers table — mason can't install it. nvim-lspconfig (loaded
-- by init.lua before this file) provides the rest of the config.
vim.lsp.config('sourcekit', {
  -- lspconfig's default also claims c/cpp; leave those alone
  filetypes = { 'swift', 'objc', 'objcpp' },
})
vim.lsp.enable 'sourcekit'

vim.pack.add {
  'https://github.com/MunifTanjim/nui.nvim',
  -- also added by debug.lua; plugin load order is unspecified, so add here too
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/wojciech-kulik/xcodebuild.nvim',
}

-- Logs are piped through xcbeautify (installed by mason, whose bin dir is on
-- nvim's PATH)
require('xcodebuild').setup {}

-- Debugging uses Xcode's lldb-dap (Xcode 16+), no codelldb needed.
-- Also loads saved breakpoints when a Swift file is opened.
local xcode_dap = require 'xcodebuild.integrations.dap'
xcode_dap.setup()

vim.keymap.set('n', '<leader>X', '<cmd>XcodebuildPicker<cr>', { desc = 'Xcodebuild actions' })
vim.keymap.set('n', '<leader>xf', '<cmd>XcodebuildProjectManager<cr>', { desc = 'Project manager' })

vim.keymap.set('n', '<leader>xb', '<cmd>XcodebuildBuild<cr>', { desc = '[B]uild' })
vim.keymap.set('n', '<leader>xB', '<cmd>XcodebuildBuildForTesting<cr>', { desc = '[B]uild for testing' })
vim.keymap.set('n', '<leader>xr', '<cmd>XcodebuildBuildRun<cr>', { desc = 'Build & [R]un' })

vim.keymap.set('n', '<leader>xt', '<cmd>XcodebuildTest<cr>', { desc = 'Run [T]ests' })
vim.keymap.set('v', '<leader>xt', '<cmd>XcodebuildTestSelected<cr>', { desc = 'Run selected [T]ests' })
vim.keymap.set('n', '<leader>xT', '<cmd>XcodebuildTestClass<cr>', { desc = 'Run test class' })
vim.keymap.set('n', '<leader>x.', '<cmd>XcodebuildTestRepeat<cr>', { desc = 'Repeat last test run' })
vim.keymap.set('n', '<leader>xe', '<cmd>XcodebuildTestExplorerToggle<cr>', { desc = 'Test [E]xplorer' })

vim.keymap.set('n', '<leader>xl', '<cmd>XcodebuildToggleLogs<cr>', { desc = 'Toggle [L]ogs' })
vim.keymap.set('n', '<leader>xc', '<cmd>XcodebuildToggleCodeCoverage<cr>', { desc = 'Toggle [C]overage' })
vim.keymap.set('n', '<leader>xC', '<cmd>XcodebuildShowCodeCoverageReport<cr>', { desc = '[C]overage report' })

vim.keymap.set('n', '<leader>xs', '<cmd>XcodebuildSelectScheme<cr>', { desc = 'Select [S]cheme' })
vim.keymap.set('n', '<leader>xd', '<cmd>XcodebuildSelectDevice<cr>', { desc = 'Select [D]evice' })
vim.keymap.set('n', '<leader>xq', '<cmd>Telescope quickfix<cr>', { desc = '[Q]uickfix list' })
vim.keymap.set('n', '<leader>xx', '<cmd>XcodebuildQuickfixLine<cr>', { desc = 'Quickfix line' })
vim.keymap.set('n', '<leader>xa', '<cmd>XcodebuildCodeActions<cr>', { desc = 'Code [A]ctions' })

-- Debugging; the F-keys and <leader>b from debug.lua work during the session
vim.keymap.set('n', '<leader>xD', xcode_dap.build_and_debug, { desc = 'Build & [D]ebug' })
vim.keymap.set('n', '<leader>xR', xcode_dap.debug_without_build, { desc = 'Debug without building' })
vim.keymap.set('n', '<leader>xX', xcode_dap.terminate_session, { desc = 'Terminate debugger' })
