# > `.zshrc' is sourced in interactive shells.
# > It should contain commands to set up aliases, functions, options, key bindings, etc.
# 
# Source: [Startup Files](https://zsh.sourceforge.io/Intro/intro_3.html)

### HISTORY ###
export HISTFILE=$XDG_STATE_HOME/zsh/history
(( HISTSIZE = (2 ** 31) - 1 ))   # Number of history can be saved in memory
(( SAVEHIST = (2 ** 31) - 1 ))   # Number of history can be saved in HISTFILE
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
### HISTORY ###



### Homebrew ###
# See: [Configuring Homebrew Completions in zsh](https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh)

# We use antigen to load oh-my-zsh, and antigen will call compinit for us. In this case, we should add the following line before we use antigen.
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
### Homebrew ###



### OH MY ZSH ###
# MAKE SURE TO PLACE THESE COMMANDS BEFORE LOADING OH MY ZSH

# Path to your oh-my-zsh installation.
export ZSH="$ZDOTDIR/ohmyzsh"

# Fix bug of zsh-users/zsh-highlighting
# See issue: [Syntax-highlighting of command will disappear after an unsuccessful completion](https://github.com/zsh-users/zsh-syntax-highlighting/issues/919)
# 
# Without setting $COMPLETION_WAITING_DOTS, oh-my-zsh won't create the "expand-or-complete-with-dots" function.
# This missing function causes a problem where highlighting disappears in specific situations.
# Additionally, if you enable it by setting to "true", red dots will show up during completion waiting.
# 
# Example situation:
# If you type "brew z" in the terminal with Homebrew installed, normally "brew" should appear in green color and "z" should be white.
# However, if you press the [tab] key, all highlighted colors will disappear.
COMPLETION_WAITING_DOTS="true"
### OH MY ZSH ###



### Antigen ###
source $(brew --prefix)/share/antigen/antigen.zsh

antigen use oh-my-zsh

# plugins
## alias
antigen bundle git

## other
antigen bundle copybuffer # press `^O` to copy buffer 

## custom
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting # should be the last bundle. see: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#antigen

# theme
# See comment for loading custom theme in antigen
# comment: [How can I have a custom theme without a public Git repo?](https://github.com/zsh-users/antigen/issues/523#issuecomment-296408835)
antigen bundle $ZDOTDIR/themes sck.zsh-theme --no-local-clone

antigen apply
### Antigen ###



### zsh-users/zsh-autosuggestions ###
# Source: https://github.com/zsh-users/zsh-autosuggestions/issues/351#issuecomment-483938570

# # This speeds up pasting w/ autosuggest
# # https://github.com/zsh-users/zsh-autosuggestions/issues/238
# pasteinit() {
#   OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
#   zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
# }

# pastefinish() {
#   zle -N self-insert $OLD_SELF_INSERT
# }
# zstyle :bracketed-paste-magic paste-init pasteinit
# zstyle :bracketed-paste-magic paste-finish pastefinish

# clear suggestion of autosuggest after pasting
# https://github.com/zsh-users/zsh-autosuggestions/issues/351
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste)
### zsh-users/zsh-autosuggestions ###
