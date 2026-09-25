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

`nvim/.config/nvim` is based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).
Customizations are kept separable so upstream syncs stay reviewable:

- `lua/custom/init.lua` — all additive config (options, keymaps, autocmds, PATH),
  loaded from init.lua by a single `require 'custom'` line.
- `lua/custom/plugins/*.lua` — own plugin specs, auto-loaded by the
  `{ import = 'custom.plugins' }` line in init.lua.
- In-place edits of kickstart's own plugin specs can't be extracted; each is
  marked with a `-- CUSTOM:` comment. When syncing upstream, re-apply everything
  `grep -n 'CUSTOM' init.lua` finds, keep the two loader lines above, and leave
  the rest of init.lua as pristine upstream.
