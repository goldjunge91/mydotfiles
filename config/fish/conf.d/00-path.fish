# 00-path.fish - Core PATH & Environment configuration
# Reads the shared path list from system/paths (used by bash, fish and zsh).

# Determine the Homebrew prefix once.
if not set -q HOMEBREW_PREFIX
    set -l brew_bin (command -v brew)
    if test -n "$brew_bin"
        set -gx HOMEBREW_PREFIX (dirname (dirname $brew_bin))
    else if test -x /opt/homebrew/bin/brew
        set -gx HOMEBREW_PREFIX /opt/homebrew
    else
        set -gx HOMEBREW_PREFIX /usr/local
    end
end

# Node version manager prefix (matches system/.n)
set -q N_PREFIX; or set -gx N_PREFIX "$HOME/.n"

# Locate the dotfiles dir via the (symlinked) fish config dir.
set -l dotfiles_dir (realpath $__fish_config_dir/../..)
set -l paths_file $dotfiles_dir/system/paths

if test -f $paths_file
    for path_entry in (string match -rv '^\s*(#|$)' < $paths_file)
        eval "set -l p $path_entry"
        if test -d $p
            fish_add_path -g -p $p
        end
    end
end

# Environment variables
set -gx WASMTIME_HOME "$HOME/.wasmtime"
set -gx PNPM_HOME "$HOME/Library/pnpm"
