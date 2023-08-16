# Define antigen hooks automatically

# It will detect hook files in $XDG_CONFIG_HOME/antigen/hooks, and add hook according to their filename
#
# A valid hook file must:
#   1. have filename with the format either '${hook_type}-${hook_target}' or '${hook_type}-${hook_target}.${hook_mode}'.
#     1.1. $hook_type must be one of "replace" | "pre" | "post".
#       1.1.1. "replace" hook will only call the hook function, and do not call the hooked target function.
#       1.1.2. "pre" hook will call the hook function first, and then call the hooked target function.
#       1.1.3. "post" hook will call the hooked target function first, and then call the hook function .
#     1.2. $hook_target must be the name of any antigen pre-defined function, but without the prefix "antigen".
#         Usually for an antigen subcommand, it will be in the format "antigen-${subcommand}".
#         For example, for the subcommand `apply`, antigen pre-defined the function "antigen-apply", and $hook_target should just be "apply".
#     1.3. $hook_mode must be either "once" or "repeat".
#         Also, $hook_mode is optional, and by default it's "repeat".
#       1.3.1. "once" mode will call hook function only once.
#       1.3.2. "repeat" mode can call the hook function repeatly (more than once).
#   2. define a function with name `${filename}-hook`
#
# An example hook is defined in $XDG_CONFIG_HOME/antigen/hooks/post-apply.once.sample
#
# For more information of an antigen hook, check the source code of antigen, especially the function `antigen-add-hook`.

for hook in $XDG_CONFIG_HOME/antigen/hooks/*
do
  HOOK_BASENAME=$(basename $hook)

  if [[ $HOOK_BASENAME =~ '\.sample$' ]] then
    # Ignore example hook
    continue
  elif [[ $HOOK_BASENAME =~ '\.(once|repeat)$' ]] then
    # If hook mode is specified
    [[ $HOOK_BASENAME =~  '^(replace|pre|post)-(.*)\.(once|repeat)$' ]] || continue
  else
    # If hook mode is not specified
    [[ $HOOK_BASENAME =~  '^(replace|pre|post)-(.*)$' ]] || continue
  fi

  ANTIGEN_HOOK_TARGET=antigen-$match[2]
  ANTIGEN_HOOK_NAME=$match[1]-$match[2]-hook
  ANTIGEN_HOOK_TYPE=$match[1]
  ANTIGEN_HOOK_MODE=$match[3]

  source $hook
  antigen-add-hook $ANTIGEN_HOOK_TARGET $ANTIGEN_HOOK_NAME $ANTIGEN_HOOK_TYPE $ANTIGEN_HOOK_MODE
  unset HOOK_BASENAME ANTIGEN_HOOK_TARGET ANTIGEN_HOOK_NAME ANTIGEN_HOOK_TYPE ANTIGEN_HOOK_MODE
done
