# Migration of `oh-my-zsh`
Migrate from loading entire `$ZSH/oh-my-zsh.sh` to using necessary features only.

Source: [comment](https://github.com/mattmc3/antidote/discussions/70#discussioncomment-6775215) of discussion [How do I use Oh-My-Zsh with antidote?](https://github.com/mattmc3/antidote/discussions/70) in [antidote](https://github.com/mattmc3/antidote).

# Introduction
I just read through the source code of [`$ZSH/oh-my-zsh.sh`](https://github.com/ohmyzsh/ohmyzsh/blob/b81915d3293cc4657cec64202b9fd991b96b4ba2/oh-my-zsh.sh), and here is a complete guide of what's going on inside `oh-my-zsh.sh`:

This README.md used code from [commit `b81915d`](https://github.com/ohmyzsh/ohmyzsh/tree/b81915d3293cc4657cec64202b9fd991b96b4ba2) of **ohmyzsh/ohmyzsh**.

# TL;DR

## Workaround example
Modify from the code above, [credit](https://github.com/mattmc3/antidote/discussions/70) to @mattmc3.

### `.zshrc`

```zsh
# Prepare antidote
source /path/to/antidote.zsh

# Set omz variables
# Check Oh My Zsh Wiki for how to set these variables.
# https://github.com/ohmyzsh/ohmyzsh/wiki/Settings
ZSH=$(antidote path ohmyzsh/ohmyzsh)
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
[[ -d $ZSH_CACHE_DIR ]] || mkdir -p $ZSH_CACHE_DIR

# Uncomment the following 2 lines if you are using plugin that accesses "$ZSH_CACHE_DIR/completions".
# mkdir -p "$ZSH_CACHE_DIR/completions"
# (( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)

# Load antidote
antidote load

# Uncomment the following lines if you want fancy completion colors.
# Make sure you enable zsh completion system beforehand
# [[ -z "$LS_COLORS" ]] || zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
```

### `.zsh_plugins.txt`
```
# Enabling zsh completion system
# If you want to enable zsh completion system, you need to make sure the order of loading plugin is correct.
# Check the following antidote discussion for how to order completion plugins.
# https://github.com/mattmc3/antidote/discussions/74

# OMZ has a lot of dependancies on its lib directory.
# Load everything in path:lib before loading any plugins
ohmyzsh/ohmyzsh path:lib
# Or selectively load libs if you are sure what you are doing
# ohmyzsh/ohmyzsh path:lib/theme-and-appearance.zsh

# Now, many plugins or themes should work fine
ohmyzsh/ohmyzsh path:plugins/git
ohmyzsh/ohmyzsh path:plugins/extract
ohmyzsh/ohmyzsh path:plugins/magic-enter
ohmyzsh/ohmyzsh path:plugins/fancy-ctrl-z
ohmyzsh/ohmyzsh path:themes/robbyrussell.zsh-theme
```


# Before initializing Oh My Zsh

This part is what you MUST have done before calling `antidote load` or sourcing your antidote static file.

## 1. Protect against non-zsh execution of Oh My Zsh (use POSIX syntax here)
This is **UNNECESSARY** as long as you use `antidote` in your zsh startup files (e.g. `.zshrc`).

<details>
  <summary>See corresponding code snippet</summary>

  [Source](https://github.com/ohmyzsh/ohmyzsh/blob/b81915d3293cc4657cec64202b9fd991b96b4ba2/oh-my-zsh.sh#L1-L39)

  ```zsh
  # Protect against non-zsh execution of Oh My Zsh (use POSIX syntax here)
  [ -n "$ZSH_VERSION" ] || {
    # ANSI formatting function (\033[<code>m)
    # 0: reset, 1: bold, 4: underline, 22: no bold, 24: no underline, 31: red, 33: yellow
    omz_f() {
      [ $# -gt 0 ] || return
      IFS=";" printf "\033[%sm" $*
    }
    # If stdout is not a terminal ignore all formatting
    [ -t 1 ] || omz_f() { :; }

    omz_ptree() {
      # Get process tree of the current process
      pid=$$; pids="$pid"
      while [ ${pid-0} -ne 1 ] && ppid=$(ps -e -o pid,ppid | awk "\$1 == $pid { print \$2 }"); do
        pids="$pids $pid"; pid=$ppid
      done

      # Show process tree
      case "$(uname)" in
      Linux) ps -o ppid,pid,command -f -p $pids 2>/dev/null ;;
      Darwin|*) ps -o ppid,pid,command -p $pids 2>/dev/null ;;
      esac

      # If ps command failed, try Busybox ps
      [ $? -eq 0 ] || ps -o ppid,pid,comm | awk "NR == 1 || index(\"$pids\", \$2) != 0"
    }

    {
      shell=$(ps -o pid,comm | awk "\$1 == $$ { print \$2 }")
      printf "$(omz_f 1 31)Error:$(omz_f 22) Oh My Zsh can't be loaded from: $(omz_f 1)${shell}$(omz_f 22). "
      printf "You need to run $(omz_f 1)zsh$(omz_f 22) instead.$(omz_f 0)\n"
      printf "$(omz_f 33)Here's the process tree:$(omz_f 22)\n\n"
      omz_ptree
      printf "$(omz_f 0)\n"
    } >&2

    return 1
  }
  ```
</details>

## 2. Define `$ZSH`, `$ZSH_CACHE_DIR`, and make sure `$ZSH_CACHE_DIR` exists
**MAKE SURE** to set these before calling `antidote load` or sourcing your antidote static file. Follow [Oh My Zsh Wiki](https://github.com/ohmyzsh/ohmyzsh/wiki/Settings) to set these variables.

<details>
  <summary>See corresponding code snippet</summary>

  [Source](https://github.com/ohmyzsh/ohmyzsh/blob/b81915d3293cc4657cec64202b9fd991b96b4ba2/oh-my-zsh.sh#L41-L53)

  ```zsh
  # If ZSH is not defined, use the current script's directory.
  [[ -z "$ZSH" ]] && export ZSH="${${(%):-%x}:a:h}"

  # Set ZSH_CACHE_DIR to the path where cache files should be created
  # or else we will use the default cache/
  if [[ -z "$ZSH_CACHE_DIR" ]]; then
    ZSH_CACHE_DIR="$ZSH/cache"
  fi

  # Make sure $ZSH_CACHE_DIR is writable, otherwise use a directory in $HOME
  if [[ ! -w "$ZSH_CACHE_DIR" ]]; then
    ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
  fi
  ```
</details>

## 3. Create `$ZSH_CACHE_DIR/completions` directory and add to `$fpath`
Some plugins use this directory to save completions. So **MAKE SURE** you create this directory if you are using any of those plugins.

<details>
  <summary>See corresponding code snippet</summary>

  [Source](https://github.com/ohmyzsh/ohmyzsh/blob/b81915d3293cc4657cec64202b9fd991b96b4ba2/oh-my-zsh.sh#L55-L57)

  ```zsh
  # Create cache and completions dir and add to $fpath
  mkdir -p "$ZSH_CACHE_DIR/completions"
  (( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)
  ```
</details>

## 4. Auto update Oh My Zsh
This is **UNNECESSARY** since we are using **antidote**, we should `antidote update --bundles` manually. Or you can write a script to automate update.

<details>
  <summary>See corresponding code snippet</summary>

  [Source](https://github.com/ohmyzsh/ohmyzsh/blob/b81915d3293cc4657cec64202b9fd991b96b4ba2/oh-my-zsh.sh#L59-L60)

  ```zsh
  # Check for updates on initial load...
  source "$ZSH/tools/check_for_upgrade.sh"
  ```
</details>

# Initializing Oh My Zsh

<!-- This part is what you MUST have done before calling `antidote load` or sourcing your antidote static file. -->

## 1. Add `"$ZSH/functions"` & `"$ZSH/completions"` to `$path`
This might be **UNNECESSARY**, because both of these 2 directories no longer exist in $ZSH, and this [PR comment](https://github.com/ohmyzsh/ohmyzsh/issues/9581#issuecomment-758159075) said:

> It's a remnant of past times. It'll probably be removed or it'll be used for something, it's not yet clear.

<details>
  <summary>See corresponding code snippet</summary>

  [Source](https://github.com/ohmyzsh/ohmyzsh/blob/b81915d3293cc4657cec64202b9fd991b96b4ba2/oh-my-zsh.sh#L64-L65)

  ```zsh
  # add a function path
  fpath=("$ZSH/functions" "$ZSH/completions" $fpath)
  ```
</details>

## 2. Initialize zsh completion system

Basically Oh My Zsh does the following 4 steps to enable zsh completion system:

1. Autoload functions that will be called below
2. Define `$ZSH_CUSTOM`
3. Add all defined plugins to $fpath, before running `compinit`
4. Call `compinit` & `zrecompile`

For **antidote**, we can just follow this discussion (https://github.com/mattmc3/antidote/discussions/74) or specifically this [comment](https://github.com/mattmc3/antidote/discussions/74#discussioncomment-5904483) to enable zsh completions in correct order.

<details>
  <summary>For more detail about zsh completion system.</summary>

  According to the documentation of zsh, [20.2.2 Autoloaded files](https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Autoloaded-files):

  > When **compinit** is run, it searches all such files accessible via **fpath**/**FPATH** and reads the first line of each of them. This line should contain one of the tags described below. Files whose first line does not start with one of these tags are not considered to be part of the completion system and will not be treated specially.

  If I understand correctly, the correct steps to initialize the zsh completion system is:

  1. Add the directory containing completion files into `$fpath`.
  2. Use the command `autoload -Uz compinit` load `compinit`.
  3. Use the command `compinit` properly to initialize the zsh completion system.
  4. (Optional) use other commands for completion system, such as `compdef`.

</details>

### 2.1. Autoload functions that will be called below

1. `compaudit` is used in `lib/compfix.zsh` and `lib/diagnostics.zsh`
2. `compinit` is used to initialize completion for the current session
3. `zrecompile` is ued to compile completion system dumpfile.

You **SHOULD** determined whether to autoload these functions by yourself.

<details>
  <summary>See corresponding code snippet</summary>

  [Source](https://github.com/ohmyzsh/ohmyzsh/blob/b81915d3293cc4657cec64202b9fd991b96b4ba2/oh-my-zsh.sh#L67-L68)

  ```zsh
  # Load all stock functions (from $fpath files) called below.
  autoload -U compaudit compinit zrecompile
  ```
</details>

### 2.2. Define `$ZSH_CUSTOM`

This is **UNNECESSARY** since we are using **antidote** to manage all custom scripts including plugins, configs, and themes.

<details>
  <summary>See corresponding code snippet</summary>

  [Source](https://github.com/ohmyzsh/ohmyzsh/blob/b81915d3293cc4657cec64202b9fd991b96b4ba2/oh-my-zsh.sh#L70-L74)

  ```zsh
  # Set ZSH_CUSTOM to the path where your custom config files
  # and plugins exists, or else we will use the default custom/
  if [[ -z "$ZSH_CUSTOM" ]]; then
      ZSH_CUSTOM="$ZSH/custom"
  fi
  ```
</details>

### 2.3. Add all defined plugins to `$fpath`, before running `compinit`

This is **UNNECESSARY** to do it manually since we are using **antidote** to manage plugins. We just need to use a correct order to load completion plugin as mentioned above.

<details>
  <summary>See corresponding code snippet</summary>

  [Source](https://github.com/ohmyzsh/ohmyzsh/blob/b81915d3293cc4657cec64202b9fd991b96b4ba2/oh-my-zsh.sh#L76-L93)

  ```zsh
  is_plugin() {
    local base_dir=$1
    local name=$2
    builtin test -f $base_dir/plugins/$name/$name.plugin.zsh \
      || builtin test -f $base_dir/plugins/$name/_$name
  }

  # Add all defined plugins to fpath. This must be done
  # before running compinit.
  for plugin ($plugins); do
    if is_plugin "$ZSH_CUSTOM" "$plugin"; then
      fpath=("$ZSH_CUSTOM/plugins/$plugin" $fpath)
    elif is_plugin "$ZSH" "$plugin"; then
      fpath=("$ZSH/plugins/$plugin" $fpath)
    else
      echo "[oh-my-zsh] plugin '$plugin' not found"
    fi
  done
  ```
</details>

### 2.4. Call `compinit` & `zrecompile`

This can be done either **Manually** or by **USING A COMPLETION PLUGINS** that does this for you. See the discussion mentioned above.

<details>
  <summary>See corresponding code snippet</summary>

  [Source](https://github.com/ohmyzsh/ohmyzsh/blob/b81915d3293cc4657cec64202b9fd991b96b4ba2/oh-my-zsh.sh#L95-L147)

  ```zsh
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
  ```
</details>

## 3. Source Oh My Zsh libs, plugins, custom configs, and theme.

Basically Oh My Zsh does the following things in this part:

1. Define `_omz_source` function
2. Source Oh My Zsh libs
3. Source plugins
4. Source custom configs
5. Source theme

For **antidote**, we can safely load all of them in your bundle file, **as long as** you don't want to [skip aliases](https://github.com/ohmyzsh/ohmyzsh#skip-aliases). If you want to skip default Oh My Zsh aliases or plugin aliases, you might want to check the implementation of the `_omz_source` function, or simply choose to not loading them.

### 3.1. Define `_omz_source` function

`_omz_source` function uses `zstyle` to determine whether to skip aliases or not.

<details>
  <summary>See corresponding code snippet</summary>

  [Source](https://github.com/ohmyzsh/ohmyzsh/blob/b81915d3293cc4657cec64202b9fd991b96b4ba2/oh-my-zsh.sh#L149-L188)

  ```zsh
  _omz_source() {
    local context filepath="$1"

    # Construct zstyle context based on path
    case "$filepath" in
    lib/*) context="lib:${filepath:t:r}" ;;         # :t = lib_name.zsh, :r = lib_name
    plugins/*) context="plugins:${filepath:h:t}" ;; # :h = plugins/plugin_name, :t = plugin_name
    esac

    local disable_aliases=0
    zstyle -T ":omz:${context}" aliases || disable_aliases=1

    # Back up alias names prior to sourcing
    local -A aliases_pre galiases_pre
    if (( disable_aliases )); then
      aliases_pre=("${(@kv)aliases}")
      galiases_pre=("${(@kv)galiases}")
    fi

    # Source file from $ZSH_CUSTOM if it exists, otherwise from $ZSH
    if [[ -f "$ZSH_CUSTOM/$filepath" ]]; then
      source "$ZSH_CUSTOM/$filepath"
    elif [[ -f "$ZSH/$filepath" ]]; then
      source "$ZSH/$filepath"
    fi

    # Unset all aliases that don't appear in the backed up list of aliases
    if (( disable_aliases )); then
      if (( #aliases_pre )); then
        aliases=("${(@kv)aliases_pre}")
      else
        (( #aliases )) && unalias "${(@k)aliases}"
      fi
      if (( #galiases_pre )); then
        galiases=("${(@kv)galiases_pre}")
      else
        (( #galiases )) && unalias "${(@k)galiases}"
      fi
    fi
  }
  ```
</details>

### 3.2. Source Oh My Zsh libs

You could load all libs with `"ohmyzsh/ohmyzsh path:lib"`, or choose the lib you want like `"ohmyzsh/ohmyzsh path:lib/theme-and-appearance.zsh"`.

<details>
  <summary>See corresponding code snippet</summary>

  [Source](https://github.com/ohmyzsh/ohmyzsh/blob/b81915d3293cc4657cec64202b9fd991b96b4ba2/oh-my-zsh.sh#L190-L195)

  ```zsh
  # Load all of the config files in ~/oh-my-zsh that end in .zsh
  # TIP: Add files you don't want in git to .gitignore
  for config_file ("$ZSH"/lib/*.zsh); do
    _omz_source "lib/${config_file:t}"
  done
  unset custom_config_file
  ```
</details>

### 3.3. Source plugins

You could load an Oh My Zsh plugin in this way: "ohmyzsh/ohmyzsh path:plugins/git".

<details>
  <summary>See corresponding code snippet</summary>

  [Source](https://github.com/ohmyzsh/ohmyzsh/blob/b81915d3293cc4657cec64202b9fd991b96b4ba2/oh-my-zsh.sh#L197-L201)

  ```zsh
  # Load all of the plugins that were defined in ~/.zshrc
  for plugin ($plugins); do
    _omz_source "plugins/$plugin/$plugin.plugin.zsh"
  done
  unset plugin
  ```
</details>

### 3.4. Source custom configs

You could load your custom configs like how you load other plugins. If you want to source a local scripts, check this discussion (https://github.com/mattmc3/antidote/discussions/75).

<details>
  <summary>See corresponding code snippet</summary>

  [Source](https://github.com/ohmyzsh/ohmyzsh/blob/b81915d3293cc4657cec64202b9fd991b96b4ba2/oh-my-zsh.sh#L203-L207)

  ```zsh
  # Load all of your custom configurations from custom/
  for config_file ("$ZSH_CUSTOM"/*.zsh(N)); do
    source "$config_file"
  done
  unset config_file
  ```
</details>

### 3.5. Source theme

You could load an Oh My Zsh plugin in this way: "ohmyzsh/ohmyzsh path:path:themes/robbyrussell.zsh-theme".

<details>
  <summary>See corresponding code snippet</summary>

  [Source](https://github.com/ohmyzsh/ohmyzsh/blob/b81915d3293cc4657cec64202b9fd991b96b4ba2/oh-my-zsh.sh#L209-L226)

  ```zsh
  # Load the theme
  is_theme() {
    local base_dir=$1
    local name=$2
    builtin test -f $base_dir/$name.zsh-theme
  }

  if [[ -n "$ZSH_THEME" ]]; then
    if is_theme "$ZSH_CUSTOM" "$ZSH_THEME"; then
      source "$ZSH_CUSTOM/$ZSH_THEME.zsh-theme"
    elif is_theme "$ZSH_CUSTOM/themes" "$ZSH_THEME"; then
      source "$ZSH_CUSTOM/themes/$ZSH_THEME.zsh-theme"
    elif is_theme "$ZSH/themes" "$ZSH_THEME"; then
      source "$ZSH/themes/$ZSH_THEME.zsh-theme"
    else
      echo "[oh-my-zsh] theme '$ZSH_THEME' not found"
    fi
  fi
  ```
</details>

## 4. Set completion colors to be the same as `ls`, after theme has been loaded

[lib/theme-and-appearance.zsh](https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/theme-and-appearance.zsh) set the default `$LS_COLORS`, and other themes might override its value.
So if you want to set fancy completion colors, **MAKE SURE** to run it after you source the `theme-and-appearance` lib or your theme.

Check the documentation of zsh, [20.3.3 Standard Styles](https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Standard-Styles), for more information about `list-colors`.

<details>
  <summary>See corresponding code snippet</summary>

  [Source](https://github.com/ohmyzsh/ohmyzsh/blob/b81915d3293cc4657cec64202b9fd991b96b4ba2/oh-my-zsh.sh#L228-L229)

  ```zsh
  [[ -z "$LS_COLORS" ]] || zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
  ```
</details>
