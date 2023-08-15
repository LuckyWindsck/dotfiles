# !! Note: make sure to source this file before applying antigen !!

# Configuring Homebrew Completions in zsh
# See: https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
# 
# This must be done before `compinit`` is called.
# Since we are using antigen to load oh-my-zsh, and antigen will call `compinit` for use when we apply antigen.
# In this case, we should run the following line before we apply antigen.
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
