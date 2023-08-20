# 2.1. Autoload functions that will be called below
# Load all stock functions (from $fpath files) called below.
autoload -U compaudit compinit zrecompile

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
