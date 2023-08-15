# Fix bug of zsh-users/zsh-autosuggestions
# See issue: https://github.com/zsh-users/zsh-autosuggestions/issues/351#issuecomment-483938570

# clear suggestion of autosuggest after pasting
# https://github.com/zsh-users/zsh-autosuggestions/issues/351
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste)
