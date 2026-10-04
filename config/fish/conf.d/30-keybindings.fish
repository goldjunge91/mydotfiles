# 30-keybindings.fish - Custom key bindings and shell environment
# Formatted according to conf-d-template.fish

function fish_user_key_bindings -d "Definiert alle benutzerdefinierten Tastenkombinationen"
    # ZOXIDE
    bind \ez z_jump_menu

    # FIFC Plugin
    bind \ey _fifc

    # FZF Suchfunktionen
    bind \ex fifc_local_search
    bind \eg fifc_global_search
    bind \ed fzf_directory_search
    bind \ep fzf_process_search
    bind \eh _fzf_search_history # Alt+H ruft FZF History-Suche auf

    # Pfeil-Hoch Taste (Up Arrow): Atuin Suche oder Standard History-Suche
    if functions -q _atuin_bind_up
        bind \e\[A _atuin_bind_up
        bind \eOA _atuin_bind_up
        bind up _atuin_bind_up
    else
        bind \e\[A history-search-backward
    end
    bind \e\[B 'history-search-forward'
    bind \e\[C 'forward-char'
    bind \e\[D 'backward-char'

    # Meta + Buchstaben (Alt-Kombinationen)
    bind \eb 'prevd-or-backward-word'
    bind \ef 'nextd-or-forward-word'
    bind \eD 'kill-word'
    bind \e\x7f 'backward-kill-word'
    bind \et 'transpose-words'
    bind \eu 'upcase-word'
    bind \el 'downcase-word'
    bind \ec 'capitalize-word'

    if test "$TERM_PROGRAM" = vscode
        bind \e. 'commandline -i (echo $history[1] | string split " ")[-1]'
        bind \e_ 'commandline -i (echo $history[1] | string split " ")[-1]'
    end
end

# Starship-Optimierungen
set -gx STARSHIP_LOG error
set -gx STARSHIP_CACHE_DIR $HOME/.cache/starship

# YSU (You Should Use) Konfiguration
set -gx YSU_MESSAGE_POSITION "before"

alias fuck=correct_previous_command
