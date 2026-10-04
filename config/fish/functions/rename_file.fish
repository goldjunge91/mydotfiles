function rename_file --description "Benennt eine Datei um mit FZF-Auswahl"
    if not type -q fzf
        echo "fzf ist nicht installiert."
        return 1
    end
    set -l old_name (ls | fzf --height 40% --reverse --prompt="Wähle Datei zum Umbenennen: ")
    if test -n "$old_name"
        read -P "Neuer Name für '$old_name': " new_name
        if test -n "$new_name"
            mv "$old_name" "$new_name"
            echo "'$old_name' wurde zu '$new_name' umbenannt."
        else
            echo "Kein neuer Name angegeben. Abgebrochen."
        end
    else
        echo "Keine Datei ausgewählt. Abgebrochen."
    end
end
