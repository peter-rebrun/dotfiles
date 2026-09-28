# dotfiles

Personal configs, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

Each top-level directory is a stow *package* mirroring the paths of its files
relative to `$HOME`:

```
nvim/.config/nvim/...      -> ~/.config/nvim/...
zsh/.zshrc, .zprofile, ...  -> ~/.zshrc, ~/.zprofile, ~/.oh-my-zsh (submodule), ~/bin/{c,connect,wt}
tmux/.tmux.conf            -> ~/.tmux.conf
wezterm/.wezterm.lua       -> ~/.wezterm.lua
scripts/bin/...            -> ~/bin/...
```

## Setup on a new machine

```sh
# 1. Clone (with the oh-my-zsh submodule)
git clone --recurse-submodules git@my.github.com:peter-rebrun/dotfiles.git ~/dotfiles

# 2. Install Homebrew (https://brew.sh), then the formulas and casks
xargs brew install < ~/dotfiles/brew_formulas.txt
xargs brew install --cask < ~/dotfiles/brew_casks.txt

# 3. Symlink the configs (stow is in brew_formulas.txt)
cd ~/dotfiles
stow nvim zsh tmux wezterm scripts
```

## Using stow

Stow must run from this directory; it symlinks a package's contents into the
parent directory (`$HOME`) by default.

```sh
cd ~/dotfiles
stow nvim          # link one package
stow -D nvim       # unlink (delete the symlinks)
stow -R nvim       # relink (after adding/removing files in a package)
stow -n -v nvim    # dry run - show what would happen
```

If a real file already exists at a target path, stow refuses; move the file
into the package (`--adopt` pulls it in, then check `git diff`) or delete it.

## Brew lists

`brew_formulas.txt` and `brew_casks.txt` in the repo root are plain
newline-separated package lists. Install them with `xargs` as above.
To capture what's currently installed back into the lists:

```sh
brew leaves > brew_formulas.txt          # formulas you installed explicitly
brew list --cask > brew_casks.txt
```

## nvim: kickstart sync workflow

`nvim/.config/nvim` is based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
(the `vim.pack` era — requires nvim 0.12+; plugins are managed by Neovim's built-in
`vim.pack`, updated with `:lua vim.pack.update()`). Customizations are kept separable
so upstream syncs stay reviewable:

- `lua/custom/init.lua` — all additive config (options, keymaps, autocmds, PATH),
  loaded from init.lua by a single `require 'custom'` line.
- `lua/custom/plugins/*.lua` — own plugins, each a standalone module doing
  `vim.pack.add` + setup; auto-loaded by the `require 'custom.plugins'` line in
  init.lua (upstream's own loader, order unspecified — keep modules independent).
- `lua/kickstart/` — pristine upstream copies of the optional modules; own variants
  of debug/lint/etc live in `lua/custom/plugins/` instead.
- In-place edits of kickstart's own config can't be extracted; each is marked with
  a `-- CUSTOM:` comment. When syncing upstream: take the new upstream init.lua,
  re-apply everything `grep -n 'CUSTOM' init.lua` finds (plus the `require 'custom'`
  and `require 'custom.plugins'` loader lines), and leave the rest pristine.

### nvim: plugin install / upgrade

Plugins are declared in code (`vim.pack.add` calls in init.lua and
`lua/custom/plugins/*.lua`) and install themselves on the next nvim start.
`nvim-pack-lock.json` pins every plugin to an exact git revision and is
committed, so a fresh machine installs the locked revisions, not latest.
Never edit it by hand.

To upgrade:

```
:lua vim.pack.update()                        -- all plugins, confirmation buffer
:lua vim.pack.update({ 'noice.nvim' })        -- one plugin
:lua vim.pack.update(nil, { offline = true }) -- preview pending updates, no fetch
```

In the confirmation buffer: `:write` applies, `:quit` aborts, `]]`/`[[` jump
between plugins, `K` shows change details, `gra` updates/skips a single plugin.
Afterwards commit the `nvim-pack-lock.json` diff; revert that commit to roll back.
Version constraints (e.g. blink.cmp `vim.version.range '1.*'`) cap how far an
update can go — edit the constraint in init.lua to cross a major version.

Exception: `terragrunt-ls` is not a vim.pack plugin. Its LSP binary is
hand-built into `~/go/bin` (`lua/custom/plugins/terragrunt-ls.lua` points at it
directly). `go install <module>@latest` does NOT work — the project's go.mod
has replace directives, which Go refuses for remote installs. Build from a
clone instead (any Go >= the version in the repo's mise.toml works; no mise
needed):

```sh
git clone --depth 1 --branch v0.0.6 https://github.com/gruntwork-io/terragrunt-ls /tmp/terragrunt-ls
cd /tmp/terragrunt-ls && go install     # installs to ~/go/bin/terragrunt-ls
```

To upgrade, repeat with the newest tag from
https://github.com/gruntwork-io/terragrunt-ls/tags — the clone is disposable.
