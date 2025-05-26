# > `.zshrc' is sourced in interactive shells.
# > It should contain commands to set up aliases, functions, options, key bindings, etc.
#
# Source: [Startup Files](https://zsh.sourceforge.io/Intro/intro_3.html)

source $XDG_CONFIG_HOME/antidote/.antidoterc
source $ZSH_CUSTOM/plugins/zsh/aliases.zsh
# !! Note: NEVER COMMENT NEXT LINE OUT. options.zsh contains HISTORY-related setting. !!
source $ZSH_CUSTOM/plugins/zsh/options.zsh
source $ZSH_CUSTOM/plugins/zsh/key-bindings.zsh
