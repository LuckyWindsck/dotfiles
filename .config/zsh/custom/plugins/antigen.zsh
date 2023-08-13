# Before using antigen
# MAKE SURE TO SOURCE THIS FILE
source $ZSH_CUSTOM/plugins/antigen-pre.zsh

# Antigen
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
antigen bundle $ZSH_CUSTOM/themes sck.zsh-theme --no-local-clone

antigen apply

# After applying antigen
source $ZSH_CUSTOM/plugins/antigen-post.zsh
