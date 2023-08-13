# Clean, simple, compatible and meaningful.
# Tested on MacOS under ANSI colors.
# It is recommended to use with a dark background.
# Colors: blue, cyan, red, green, white, yellow
# 
# Mar 2023 LuckyWindsck
# modified from `ys` theme by Yad Smood

PROMPT_SHARP="%{$terminfo[bold]$fg[blue]%}#%{$reset_color%}"
PROMPT_USER="%{$fg[cyan]%}%n"
PROMPT_HEART="%{$fg[red]%}❤"
PROMPT_MACHINE="%{$fg[green]%}%m"
PROMPT_IN="%{$fg[white]%}in"
PROMPT_DIRECTORY="%{$fg[yellow]%}%~%{$reset_color%}"
PROMPT_TIME="%{$fg[white]%}[%*]"
PROMPT_LAST_EXIT_CODE="%(?,,EXIT_CODE:%{$fg[red]%}%?%{$reset_color%})"
PROMPT_CHAR="%{$terminfo[bold]$fg[red]%}› %{$reset_color%}"

# Git info
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[white]%}on%{$reset_color%} %{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}x"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}o"

# Prompt format:
# # USER @ MACHINE in DIRECTORY on BRANCH STATE [TIME] EXIT_CODE:LAST_EXIT_CODE
# › COMMAND
#
# For example:
# # luckywind @ sck in ~/.oh-my-zsh on master x [21:47:42] EXIT_CODE:0
# ›

PROMPT="${PROMPT_SHARP} ${PROMPT_USER} ${PROMPT_HEART} ${PROMPT_MACHINE} ${PROMPT_IN} ${PROMPT_DIRECTORY}${git_info} ${PROMPT_TIME} ${PROMPT_LAST_EXIT_CODE}
${PROMPT_CHAR}"
