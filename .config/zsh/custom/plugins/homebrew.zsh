# See: [Configuring Homebrew Completions in zsh](https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh)
# 
# We use antigen to load oh-my-zsh, and antigen will call compinit for us. In this case, we should add the following line before we use antigen.
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
