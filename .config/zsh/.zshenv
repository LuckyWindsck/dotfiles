# > `.zshenv' is sourced on all invocations of the shell, unless the -f option is set.
# > It should contain commands to set the command search path, plus other important environment variables.
# > `.zshenv' should not contain commands that produce output or assume the shell is attached to a tty.
# 
# Source: [Startup Files](https://zsh.sourceforge.io/Intro/intro_3.html)

### XDG Base Directory Specification ###
# Set environment variables for [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache
### XDG Base Directory Specification ###

### HomeBrew ###
# Set shell env for HomeBrew according to the instruction after installation
eval "$(/opt/homebrew/bin/brew shellenv)"
### HomeBrew ###

export ADOTDIR=$XDG_DATA_HOME/antigen
ANTIGEN_CACHE_DIR=$XDG_CACHE_HOME/antigen
export ANTIGEN_CACHE=$ANTIGEN_CACHE_DIR/init.zsh
