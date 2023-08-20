# Clean, simple, compatible and meaningful.
# Tested on MacOS under ANSI colors.
# It is recommended to use with a dark background.
# Colors: blue, cyan, red, green, white, yellow
#
# Aug 2023 LuckyWindsck
# modified from `ys` theme by Yad Smood

# Set variables used in `git_prompt_info` function
# See: `ohmyzsh/lib/git.zsh` for definition of `git_prompt_info` and usage of these variables
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}on%{$reset_color%} %{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}x"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}o"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

sck_zsh_theme () {
  # First line
  local SCK_THEME_SHARP="%{$terminfo[bold]$fg[blue]%}#%{$reset_color%}"
  local SCK_THEME_USER="%{$fg[cyan]%}%n"
  local SCK_THEME_HEART="%{$fg[red]%}❤"
  local SCK_THEME_MACHINE="%{$fg[green]%}%m"
  local SCK_THEME_IN="%{$fg[white]%}in"
  local SCK_THEME_DIRECTORY="%{$fg[yellow]%}%~%{$reset_color%}"
  local SCK_THEME_GIT_INFO='$(git_prompt_info)'
  local SCK_THEME_TIME="%{$fg[white]%}[%*]"
  local SCK_THEME_LAST_EXIT_CODE="%(?,,EXIT_CODE:%{$fg[red]%}%?%{$reset_color%})"

  # Second Line
  local SCK_THEME_CHAR="%{$terminfo[bold]$fg[red]%}› %{$reset_color%}"

  # Prompt
  echo $SCK_THEME_SHARP $SCK_THEME_USER $SCK_THEME_HEART $SCK_THEME_MACHINE $SCK_THEME_IN $SCK_THEME_DIRECTORY $SCK_THEME_GIT_INFO $SCK_THEME_TIME $SCK_THEME_LAST_EXIT_CODE
  echo $SCK_THEME_CHAR
}

# Prompt format:
# # USER ❤ MACHINE in DIRECTORY on BRANCH STATE [TIME] EXIT_CODE:LAST_EXIT_CODE
# › COMMAND
#
# For example:
# # luckywind ❤ sck in ~/.oh-my-zsh on main x [21:47:42] EXIT_CODE:1
# ›

PROMPT=$(sck_zsh_theme)
