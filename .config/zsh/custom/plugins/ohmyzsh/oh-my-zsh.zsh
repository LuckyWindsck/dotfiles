# Migrate from loading entire `$ZSH/oh-my-zsh.sh` to using necessary features only.
# See comment: [How do I use Oh-My-Zsh with antidote?](https://github.com/mattmc3/antidote/discussions/70#discussioncomment-6775215)

# Before initializing Oh My Zsh

# 1. Protect against non-zsh execution of Oh My Zsh (use POSIX syntax here)
# Unnecessary, because we source this file via `.zshrc`.

# 2. Define $ZSH, $ZSH_CACHE_DIR, and make sure $ZSH_CACHE_DIR exists
# Unnecessary, because we set these variables in `.zshenv` and `mkdir $ZSH_CACHE_DIR` to ensure it exists.

# 3. Create `$ZSH_CACHE_DIR/completions` directory and add to `$fpath`
# TODO: check if this is necessary.
# Some plugins use this directory to save completions, so make sure to `mkdir` if we are using any of those plugins.
_init_completion_cache () {
  mkdir -p "$ZSH_CACHE_DIR/completions"
  (( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)
}

_init_completion_cache

# 4. Auto update Oh My Zsh
# TODO: consider whether to enable or not.
# source "$ZSH/tools/check_for_upgrade.sh"

# ---------- #

# Initializing Oh My Zsh

# 1. Add `"$ZSH/functions"` & `"$ZSH/completions"` to `$path`
# TODO: might be unnecessary, because both of these 2 directories no longer exist in `$ZSH`.
# fpath=("$ZSH/functions" "$ZSH/completions" $fpath)

# 2. Initialize zsh completion system
_init_completion_system () {
  # 2.1. Autoload functions that will be called below
  autoload -U compaudit compinit zrecompile

  # 2.2. Define `$ZSH_CUSTOM`
  # Unnecessary, we set it in `.zshenv`.

  # 2.3. Add all defined plugins to `$fpath`, before running `compinit`
  # Unnecessary, because we use `antidote` to manage plugins.

  # 2.4. Call `compinit` & `zrecompile`
  # Figure out the SHORT hostname
  if [[ "$OSTYPE" = darwin* ]]; then
    # macOS's $HOST changes with dhcp, etc. Use ComputerName if possible.
    SHORT_HOST=$(scutil --get ComputerName 2>/dev/null) || SHORT_HOST="${HOST/.*/}"
  else
    SHORT_HOST="${HOST/.*/}"
  fi

  # Save the location of the current completion dump file.
  if [[ -z "$ZSH_COMPDUMP" ]]; then
    ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"
  fi

  # Construct zcompdump OMZ metadata
  zcompdump_revision="#omz revision: $(builtin cd -q "$ZSH"; git rev-parse HEAD 2>/dev/null)"
  zcompdump_fpath="#omz fpath: $fpath"

  # Delete the zcompdump file if OMZ zcompdump metadata changed
  if ! command grep -q -Fx "$zcompdump_revision" "$ZSH_COMPDUMP" 2>/dev/null \
    || ! command grep -q -Fx "$zcompdump_fpath" "$ZSH_COMPDUMP" 2>/dev/null; then
    command rm -f "$ZSH_COMPDUMP"
    zcompdump_refresh=1
  fi

  if [[ "$ZSH_DISABLE_COMPFIX" != true ]]; then
    source "$ZSH/lib/compfix.zsh"
    # Load only from secure directories
    compinit -i -d "$ZSH_COMPDUMP"
    # If completion insecurities exist, warn the user
    handle_completion_insecurities &|
  else
    # If the user wants it, load from all found directories
    compinit -u -d "$ZSH_COMPDUMP"
  fi

  # Append zcompdump metadata if missing
  if (( $zcompdump_refresh )) \
    || ! command grep -q -Fx "$zcompdump_revision" "$ZSH_COMPDUMP" 2>/dev/null; then
    # Use `tee` in case the $ZSH_COMPDUMP filename is invalid, to silence the error
    # See https://github.com/ohmyzsh/ohmyzsh/commit/dd1a7269#commitcomment-39003489
    tee -a "$ZSH_COMPDUMP" &>/dev/null <<EOF

$zcompdump_revision
$zcompdump_fpath
EOF
  fi
  unset zcompdump_revision zcompdump_fpath zcompdump_refresh

  # zcompile the completion dump file if the .zwc is older or missing.
  if command mkdir "${ZSH_COMPDUMP}.lock" 2>/dev/null; then
    zrecompile -q -p "$ZSH_COMPDUMP"
    command rm -rf "$ZSH_COMPDUMP.zwc.old" "${ZSH_COMPDUMP}.lock"
  fi
}

_init_completion_system

# 3. Source Oh My Zsh libs, plugins, custom configs, and theme.
# 3.1. Define `_omz_source` function
# TODO: see whether we need to skip aliases or not.
# _omz_source() {
#   local context filepath="$1"

#   # Construct zstyle context based on path
#   case "$filepath" in
#   lib/*) context="lib:${filepath:t:r}" ;;         # :t = lib_name.zsh, :r = lib_name
#   plugins/*) context="plugins:${filepath:h:t}" ;; # :h = plugins/plugin_name, :t = plugin_name
#   esac

#   local disable_aliases=0
#   zstyle -T ":omz:${context}" aliases || disable_aliases=1

#   # Back up alias names prior to sourcing
#   local -A aliases_pre galiases_pre
#   if (( disable_aliases )); then
#     aliases_pre=("${(@kv)aliases}")
#     galiases_pre=("${(@kv)galiases}")
#   fi

#   # Source file from $ZSH_CUSTOM if it exists, otherwise from $ZSH
#   if [[ -f "$ZSH_CUSTOM/$filepath" ]]; then
#     source "$ZSH_CUSTOM/$filepath"
#   elif [[ -f "$ZSH/$filepath" ]]; then
#     source "$ZSH/$filepath"
#   fi

#   # Unset all aliases that don't appear in the backed up list of aliases
#   if (( disable_aliases )); then
#     if (( #aliases_pre )); then
#       aliases=("${(@kv)aliases_pre}")
#     else
#       (( #aliases )) && unalias "${(@k)aliases}"
#     fi
#     if (( #galiases_pre )); then
#       galiases=("${(@kv)galiases_pre}")
#     else
#       (( #galiases )) && unalias "${(@k)galiases}"
#     fi
#   fi
# }

# 3.2. Source Oh My Zsh libs
for config_file ("$ZSH"/lib/*.zsh); do
  source $config_file
done
unset config_file

# 3.3. Source plugins
# 3.4. Source custom configs
# 3.5. Source theme
# Unnecessary, because we use `antidote` to manage plugins, configs, and theme.

# 4. Set completion colors to be the same as `ls`, after theme has been loaded
[[ -z "$LS_COLORS" ]] || zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
