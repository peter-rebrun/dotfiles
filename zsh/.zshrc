# Vanilla zsh + starship prompt. oh-my-zsh was removed; the few lib/ behaviours
# worth keeping are set explicitly below (history, completion, arrow search).

# --- Completion ---
# Docker CLI completions must be on fpath before compinit
fpath=(/Users/peter/.docker/completions $fpath)
autoload -Uz compinit
compinit
# Case-insensitive, hyphen/underscore-insensitive, partial-word matching (as OMZ had)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$HOME/.zcompcache"

# --- History ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt extended_history       # save timestamps
setopt share_history          # share across sessions
setopt hist_ignore_dups       # skip immediate duplicates
setopt hist_expire_dups_first # trim duplicates first when history is full
setopt hist_ignore_space      # commands starting with space stay out
setopt hist_verify            # expand ! history before running
alias history='fc -il 1'      # timestamped listing (like OMZ HIST_STAMPS)

# Allow # comments on the interactive command line
setopt interactive_comments

# --- Keybindings: arrows search history filtered by the typed prefix ---
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# Aliases
alias vim="nvim"
alias ls="eza --icons=always --group-directories-first"
alias l="ls -lh"
alias ll="ls -lha"
# alias cdc="cd ~/code"

# Created by `pipx` on 2024-03-27 03:55:06
export PATH="$PATH:$HOME/.local/bin"

# Set up fzf key bindings and fuzzy completion
FZF_CTRL_T_COMMAND= source <(fzf --zsh)
# export FZF_CTRL_R_OPTS="--reverse"
# fzf >=0.74 renders multi-line history entries expanded and rebound ctrl-/ to
# toggle-wrap-word; show one line per entry and fold/unfold with ctrl-/ instead.
export FZF_CTRL_R_OPTS="--no-multi-line --bind 'ctrl-/:toggle-multi-line'"
# Alt-C directory widget: tree preview of the highlighted directory,
# hidden files included but VCS/dependency/cache dirs pruned
export FZF_ALT_C_OPTS="--preview 'eza --tree --all --level=2 --color=always --ignore-glob=\".git|node_modules|.terraform|.venv|__pycache__|.cache|.turbo|.pytest_cache|.DS_Store\" {}'"
export FZF_TMUX_OPTS="-p"

# Import functions to mange git worktrees
source $HOME/bin/wt
source $HOME/bin/c

export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="$HOME/.ebcli-virtual-env/executables:$PATH"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

source $HOME/.splose-secrets
export AWS_PAGER=""

# Volta must beat brew's node (kept for gemini-cli/prettierd); .zshenv prepends
# it too early — .zprofile's brew shellenv would otherwise shadow it.
export PATH="$HOME/.volta/bin:$PATH"

# --- Prompt ---
eval "$(starship init zsh)"

# --- Plugins (brew-installed). Syntax highlighting must be sourced last. ---
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
