# > `.zshenv' is sourced on all invocations of the shell, unless the -f option is set.
# > It should contain commands to set the command search path, plus other important environment variables.
# > `.zshenv' should not contain commands that produce output or assume the shell is attached to a tty.
# 
# Source: [Startup Files](https://zsh.sourceforge.io/Intro/intro_3.html)

# !! Note: make sure to `mkdir` when necessary !!

# XDG Base Directory Specification
# See: [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache
mkdir -p $XDG_DATA_HOME $XDG_CONFIG_HOME $XDG_STATE_HOME $XDG_CACHE_HOME

# oh-my-zsh
export ZSH=$ZDOTDIR/ohmyzsh
export ZSH_CACHE_DIR=$XDG_CACHE_HOME/zsh
export ZSH_CUSTOM=$ZDOTDIR/custom
export ZSH_COMPDUMP=$ZSH_CACHE_DIR/.zcompdump
# Oh My Zsh will create those directories for us.

# homebrew
# Set shell env for HomeBrew according to the instruction after installation.
eval "$(/opt/homebrew/bin/brew shellenv)"

# antidote
mkdir -p {$XDG_DATA_HOME,$XDG_CONFIG_HOME,$XDG_CACHE_HOME}/antidote
# See: [Usage](https://getantidote.github.io/usage#cleanmymac-or-similar-tools)
# See comment: https://github.com/mattmc3/antidote/issues/129#issuecomment-1565834910
export ANTIDOTE_HOME=$XDG_CACHE_HOME/antidote

# rime
# This is where we clone repo, so we don't need to `mkdir`.
# See: [plum](https://github.com/rime/plum#advanced-usage)
export plum_dir=$XDG_DATA_HOME/rime/plum

# less
mkdir -p $XDG_STATE_HOME/less
# See: `man less`
export LESSHISTFILE=$XDG_STATE_HOME/less/history
