# MIGRATION PROCESS

## Before initializing Oh My Zsh

### 1. Protect against non-zsh execution of Oh My Zsh (use POSIX syntax here)
**Unnecessary**, because we source this file via `.zshrc`.

### 2. Define $ZSH, $ZSH_CACHE_DIR, and make sure $ZSH_CACHE_DIR exists
**Unnecessary**, because we set these variables in `.zshenv` and `mkdir $ZSH_CACHE_DIR` to ensure it exists.

### 3. Create `$ZSH_CACHE_DIR/completions` directory and add to `$fpath`
**TODO**: check if this is necessary.
Some plugins use this directory to save completions, so make sure to `mkdir` if we are using any of those plugins.

### 4. Auto update Oh My Zsh
**Necessary**

## Initializing Oh My Zsh

### 1. Add `"$ZSH/functions"` & `"$ZSH/completions"` to `$path`
**TODO**: might be unnecessary, because both of these 2 directories no longer exist in `$ZSH`.

### 2. Initialize zsh completion system
#### 2.1. Autoload functions that will be called below
**Necessary**, in order to initialize zsh completion system

#### 2.2. Define `$ZSH_CUSTOM`
**Unnecessary**, we set it in `.zshenv`.

#### 2.3. Add all defined plugins to `$fpath`, before running `compinit`
**Unnecessary**, because we use `antidote` to manage plugins.

#### 2.4. Call `compinit` & `zrecompile`
**Necessary**, in order to initialize zsh completion system

### 3. Source Oh My Zsh libs, plugins, custom configs, and theme.
#### 3.1. Define `_omz_source` function
**TODO**: see whether we need to skip aliases or not.

#### 3.2. Source Oh My Zsh libs
**TODO**: select only necessary lib to load

#### 3.3. Source plugins
#### 3.4. Source custom configs
#### 3.5. Source theme
**Unnecessary**, because we use `antidote` to manage plugins, configs, and theme.

### 4. Set completion colors to be the same as `ls`, after theme has been loaded
**Necessary**, in order to have fancy completion colors
