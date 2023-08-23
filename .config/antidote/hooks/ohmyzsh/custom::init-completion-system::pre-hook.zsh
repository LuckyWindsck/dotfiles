# !! Note: make sure to set this function as pre-hook for the plugin that calls `compinit` !!

# Set `$fpath` for zsh completion system
# See: [20 Completion System](https://zsh.sourceforge.io/Doc/Release/Completion-System.html)
_set-completion-fpath () {
  fpath=(
    # Homebrew
    # See: [Configuring Homebrew Completions in zsh](https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh)
    $(brew --prefix)/share/zsh/site-functions

    $fpath
  )
}
