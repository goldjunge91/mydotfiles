# 20-lazy-load.fish - Deferred loading of prompt components
# Formatted according to conf-d-template.fish

function defer --on-event fish_prompt -d "Lädt schwere Komponenten verzögert beim ersten Prompt"
    functions -e defer

    if type -q atuin
        atuin init fish | source
        if functions -q _atuin_bind_up
            bind \e\[A _atuin_bind_up
            bind \eOA _atuin_bind_up
            bind up _atuin_bind_up
        end
    end

    if type -q zoxide
        zoxide init fish | source
    end

    if type -q thefuck
        thefuck --alias | source
    end

    if type -q register-python-argcomplete; and type -q pipx
        if not test -f ~/.config/fish/completions/pipx.fish
            register-python-argcomplete --shell fish pipx >~/.config/fish/completions/pipx.fish
        end
    end
end
