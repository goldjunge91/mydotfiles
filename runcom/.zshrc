# ~/.zshrc — zsh entry point for the dotfiles.
# Shares PATH with bash and fish via system/paths.

# Resolve DOTFILES_DIR
if [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
elif [ -d "$HOME/dotfiles" ]; then
  DOTFILES_DIR="$HOME/dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

# Make dotfiles utilities available
PATH="$DOTFILES_DIR/bin:$PATH"

# Shared PATH (same list as bash and fish)
. "$DOTFILES_DIR/system/.path"

# Environment variables
[ -f "$DOTFILES_DIR/system/.env" ] && . "$DOTFILES_DIR/system/.env"

export DOTFILES_DIR
