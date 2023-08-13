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
