# 00-path.fish - Core PATH & Environment configuration
# Use -g -p (global session prepend) to avoid universal variable pollution

# Determine the Homebrew prefix once: /opt/homebrew on Apple Silicon,
# /usr/local on Intel. Must be set before the gnubin paths below.
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

# Core developer paths (prepended in order of priority)
set -l user_paths \
    $HOME/.local/bin \
    $HOME/bin \
    $HOME/.cargo/bin \
    $HOME/.bun/bin \
    $HOME/.maestro/bin \
    $HOME/Library/pnpm \
    $HOME/.wasmtime/bin \
    $HOME/.local/share/fnm/aliases/default/bin \
    /Applications/ArmGNUToolchain/14.3.rel1/arm-none-eabi/bin \
    $HOME/.codeium/windsurf/bin \
    $HOME/.antigravity/antigravity/bin \
    $HOME/.antigravity-ide/antigravity-ide/bin

# GNU coreutils install into gnubin only. Without these, sed/awk/tar/grep/find/
# patch silently resolve to the BSD versions on macOS.
set -l gnu_paths \
    $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin \
    $HOMEBREW_PREFIX/opt/findutils/libexec/gnubin \
    $HOMEBREW_PREFIX/opt/gawk/libexec/gnubin \
    $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin \
    $HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin \
    $HOMEBREW_PREFIX/opt/gpatch/libexec/gnubin \
    $HOMEBREW_PREFIX/opt/grep/libexec/gnubin \
    $HOMEBREW_PREFIX/opt/make/libexec/gnubin

for p in $user_paths $gnu_paths
    if test -d $p
        fish_add_path -g -p $p
    end
end

# Environment variables
set -gx WASMTIME_HOME "$HOME/.wasmtime"
set -gx PNPM_HOME "$HOME/Library/pnpm"
