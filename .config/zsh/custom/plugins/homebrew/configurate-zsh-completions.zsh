# !! Note: make sure to source this file before calling `compinit` (before loading oh-my-zsh) !!

# Configuring Homebrew Completions in zsh
# See: https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
# 
# This must be done before `compinit` is called.
# Since we are using Oh My Zsh, and Oh My Zsh will call `compinit` for us when we source oh-my-zsh.sh.
# In this case, we should run the following line before we source oh-my-zsh.sh.
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
