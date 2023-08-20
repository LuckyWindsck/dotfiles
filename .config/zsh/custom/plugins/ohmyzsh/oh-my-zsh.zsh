# Before initializing Oh My Zsh

# 3. Create `$ZSH_CACHE_DIR/completions` directory and add to `$fpath`
# TODO: check if this is necessary.
# Some plugins use this directory to save completions, so make sure to `mkdir` if we are using any of those plugins.
source $ZSH_CUSTOM/plugins/ohmyzsh/init-completion-cache.zsh

# 4. Auto update Oh My Zsh
source $ZSH/tools/check_for_upgrade.sh

# ---------- #

# Initializing Oh My Zsh

# 1. Add `"$ZSH/functions"` & `"$ZSH/completions"` to `$path`
# TODO: might be unnecessary, because both of these 2 directories no longer exist in `$ZSH`.
# fpath=("$ZSH/functions" "$ZSH/completions" $fpath)

# 2. Initialize zsh completion system
source $ZSH_CUSTOM/plugins/ohmyzsh/init-completion-system.zsh

# 3. Source Oh My Zsh libs, plugins, custom configs, and theme.
# 3.1. Define `_omz_source` function
# TODO: see whether we need to skip aliases or not.
# source $ZSH_CUSTOM/plugins/ohmyzsh/_omz_source.zsh

# 3.2. Source Oh My Zsh libs
for config_file ("$ZSH"/lib/*.zsh); do
  source $config_file
done
unset config_file

# 4. Set completion colors to be the same as `ls`, after theme has been loaded
source $ZSH_CUSTOM/plugins/ohmyzsh/set-completion-colors.zsh
