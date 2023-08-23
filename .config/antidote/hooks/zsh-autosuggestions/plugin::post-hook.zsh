# Fix bug of zsh-users/zsh-autosuggestions
# See issue: https://github.com/zsh-users/zsh-autosuggestions/issues/351#issuecomment-483938570

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
_speed-up-pasting () {
  pasteinit() {
    OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
    zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
  }

  pastefinish() {
    zle -N self-insert $OLD_SELF_INSERT
  }
  zstyle :bracketed-paste-magic paste-init pasteinit
  zstyle :bracketed-paste-magic paste-finish pastefinish
}

# clear suggestion of autosuggest after pasting
# https://github.com/zsh-users/zsh-autosuggestions/issues/351
_clear-suggestion-after-pasting () {
  ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste)
}

# !! Note: make sure to set this function as post-hook for the "zsh-users/zsh-autosuggestions" plugin !!
_fix-zsh-autosuggestions () {
  _speed-up-pasting
  _clear-suggestion-after-pasting
}
