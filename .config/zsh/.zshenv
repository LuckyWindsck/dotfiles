# > `.zshenv' is sourced on all invocations of the shell, unless the -f option is set.
# > It should contain commands to set the command search path, plus other important environment variables.
# > `.zshenv' should not contain commands that produce output or assume the shell is attached to a tty.
# 
# Source: [Startup Files](https://zsh.sourceforge.io/Intro/intro_3.html)

export XDG_DATA_HOME=$HOME/.local/share/
export XDG_CONFIG_HOME=$HOME/.config/
export XDG_STATE_HOME=$HOME/.local/state/
export XDG_CACHE_HOME=$HOME/.cache/
