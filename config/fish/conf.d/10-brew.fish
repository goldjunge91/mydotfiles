# 10-brew.fish - Homebrew configuration & performance optimizations
# Formatted according to conf-d-template.fish

# Homebrew shellenv is loaded exactly once by the installer's managed file.

# 00-path.fish runs first and determines HOMEBREW_PREFIX.
if not set -q HOMEBREW_PREFIX
    set -gx HOMEBREW_PREFIX (brew --prefix 2>/dev/null)
    if test -z "$HOMEBREW_PREFIX"
        set -gx HOMEBREW_PREFIX /opt/homebrew
    end
end

# Homebrew optimizations
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_BUNDLE_FILE_GLOBAL "$HOME/.config/brewfile/Brewfile"

# Add Homebrew paths to MANPATH and INFOPATH if they exist
if test -d $HOMEBREW_PREFIX/share/man
    set -gx MANPATH $HOMEBREW_PREFIX/share/man $MANPATH
end

if test -d $HOMEBREW_PREFIX/share/info
    set -gx INFOPATH $HOMEBREW_PREFIX/share/info $INFOPATH
end

# Homebrew completions
if test -d $HOMEBREW_PREFIX/share/fish/completions
    set -gx fish_complete_path $HOMEBREW_PREFIX/share/fish/completions $fish_complete_path
end

if test -d $HOMEBREW_PREFIX/share/fish/vendor_completions.d
    set -gx fish_complete_path $HOMEBREW_PREFIX/share/fish/vendor_completions.d $fish_complete_path
end

# Prompt directory length
set -g fish_prompt_pwd_dir_length 2

# iTerm2 Integration
if test "$TERM_PROGRAM" = "iTerm.app"; and test -e $HOME/.iterm2_shell_integration.fish
    set -gx TERM_FEATURES "256color:mouse:clipboard"
    source $HOME/.iterm2_shell_integration.fish
end
