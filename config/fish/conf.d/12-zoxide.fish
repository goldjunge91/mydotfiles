# 12-zoxide.fish - Zoxide configuration & helper commands
# Formatted according to conf-d-template.fish

if not type -q zoxide
    exit 0
end

set -gx _ZO_ECHO 0
set -gx _ZO_RESOLVE_SYMLINKS 1
set -gx _ZO_EXCLUDE_DIRS "$HOME"
set -gx _ZO_MAXAGE 10000

if status is-interactive
    alias zi="zoxide query -i"
end

function z_clean --description "Bereinigt Zoxide-Datenbank von nicht existierenden Pfaden"
    if not type -q zoxide
        echo "Zoxide ist nicht installiert."
        return 1
    end

    echo "Bereinige Zoxide-Datenbank..."
    set -l before_count (zoxide query --list | wc -l | string trim)
    echo "Einträge vor Bereinigung: $before_count"

    set -l removed_count 0
    zoxide query --list | while read -l path
        if not test -d "$path"
            zoxide remove "$path" 2>/dev/null
            set removed_count (math $removed_count + 1)
            echo "Entfernt: $path"
        end
    end

    set -l after_count (zoxide query --list | wc -l | string trim)
    echo "Einträge nach Bereinigung: $after_count"
    echo "Entfernte Einträge: $removed_count"
end

function z_top --description "Zeigt die 10 häufigsten Verzeichnisse aus Zoxide"
    if not type -q zoxide
        echo "Zoxide ist nicht installiert."
        return 1
    end

    echo "Die 10 am häufigsten besuchten Verzeichnisse:"
    zoxide query --list --score | head -10
end

function z_import_all --description "Importiert Daten von fasd, autojump und z.lua in Zoxide"
    if test -f "$HOME/.fasd"
        echo "Importiere fasd-Daten..."
        zoxide import --from fasd "$HOME/.fasd"
    end

    if test -f "$HOME/.local/share/autojump/autojump.txt"
        echo "Importiere autojump-Daten..."
        zoxide import --from autojump "$HOME/.local/share/autojump/autojump.txt"
    end

    if test -f "$HOME/.zlua"
        echo "Importiere z.lua-Daten..."
        zoxide import --from z.lua "$HOME/.zlua"
    end

    echo "Import abgeschlossen."
end
