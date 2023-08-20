# !! Note: make sure to source this file before loading oh-my-zsh !!

# Fix bug of zsh-users/zsh-highlighting
# See issue: [Syntax-highlighting of command will disappear after an unsuccessful completion](https://github.com/zsh-users/zsh-syntax-highlighting/issues/919)
#
# Without setting $COMPLETION_WAITING_DOTS, oh-my-zsh won't create the "expand-or-complete-with-dots" function.
# This missing function causes a problem where highlighting disappears in specific situations.
# Additionally, if you enable it by setting to "true", red dots will show up during completion waiting.
#
# Example situation:
# If you type "brew z" in the terminal with Homebrew installed, normally "brew" should appear in green color and "z" should be white.
# However, if you press the [tab] key, all highlighted colors will disappear.
COMPLETION_WAITING_DOTS="true"
