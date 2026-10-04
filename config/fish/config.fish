# Docker Desktop commands, if installed.
fish_add_path --move "$HOME/.docker/bin"

# Main Fish Configuration
# Keep minimal; modular configs are auto-loaded from conf.d/

set -g fish_greeting ""

if status is-interactive
    # Interactive settings
    set -g fish_autosuggestion_enabled 1
    set -g fish_key_bindings fish_default_key_bindings

    # Starship Prompt Configuration
    if type -q starship
        set -gx STARSHIP_LOG error
        set -gx STARSHIP_CACHE_DIR $HOME/.cache/starship

        function starship_transient_prompt_func --description "Zeigt den transienten Starship-Prompt (links)"
            starship module character
        end

        function starship_transient_rprompt_func --description "Zeigt den transienten Starship-Prompt (rechts)"
            starship module status
            starship module cmd_duration
            starship module battery
            starship module time
        end

        starship init fish | source
        enable_transience
    end
end

if test "$TERM_PROGRAM" = vscode; and set -q VSCODE_FISH_ACTIVATE
    eval $VSCODE_FISH_ACTIVATE
end

# Autocompletion for dctx
complete -c dctx -n __fish_use_subcommand -a "(docker context ls --format '{{.Name}}')" -d "Docker Context"


# `$HOME/.local/bin` is managed once by conf.d/00-path.fish.

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish


# The Antigravity IDE path is managed once by conf.d/00-path.fish.

# kimi-code
fish_add_path -g "$HOME/.kimi-code/bin"
