function z_jump_menu --description "Zeigt interaktives Menü der Zoxide-Verzeichnisse mit FZF"
    if not type -q zoxide; or not type -q fzf
        echo "zoxide oder fzf ist nicht installiert."
        return 1
    end

    set -l query (zoxide query -l | fzf --height 40% --reverse --prompt="Wähle Verzeichnis: " \
        --preview 'test -d {} && ls -la {} || echo "Verzeichnis nicht gefunden"' \
        --preview-window 'right:60%:wrap')

    if test -n "$query"
        cd $query
        commandline -f repaint
    else
        echo "Kein Verzeichnis ausgewählt."
    end
end
