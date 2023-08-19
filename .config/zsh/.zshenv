# > `.zshenv' is sourced on all invocations of the shell, unless the -f option is set.
# > It should contain commands to set the command search path, plus other important environment variables.
# > `.zshenv' should not contain commands that produce output or assume the shell is attached to a tty.
# 
# Source: [Startup Files](https://zsh.sourceforge.io/Intro/intro_3.html)

# XDG Base Directory Specification
# See: [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

# zsh
export ZSH_CUSTOM=$ZDOTDIR/custom

# oh-my-zsh
export ZSH=$ZDOTDIR/ohmyzsh # Path to your oh-my-zsh installation.

# homebrew
# Set shell env for HomeBrew according to the instruction after installation
eval "$(/opt/homebrew/bin/brew shellenv)"

# antigen
# See: [Configuration](https://github.com/zsh-users/antigen/wiki/Configuration)
export ADOTDIR=$XDG_DATA_HOME/antigen
ANTIGEN_CACHE_DIR=$XDG_CACHE_HOME/antigen
[ -d $ANTIGEN_CACHE_DIR ] || mkdir $ANTIGEN_CACHE_DIR
export ANTIGEN_CACHE=false
export ANTIGEN_LOG=$ANTIGEN_CACHE_DIR/antigen.log
[ -d $XDG_CACHE_HOME/zsh ] || mkdir $XDG_CACHE_HOME/zsh
export ANTIGEN_COMPDUMP=$XDG_CACHE_HOME/zsh/.zcompdump-antigen

# rime
# See: [plum](https://github.com/rime/plum#advanced-usage)
export plum_dir=$XDG_DATA_HOME/rime/plum

# less
LESS_HIST_DIR=$XDG_STATE_HOME/less
[ -d $LESS_HIST_DIR ] || mkdir $LESS_HIST_DIR
export LESSHISTFILE=$XDG_STATE_HOME/less/history
