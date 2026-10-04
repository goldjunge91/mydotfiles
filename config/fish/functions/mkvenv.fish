function mkvenv --description "Erstellt eine Python venv im aktuellen Verzeichnis mit uv"
    # Prüfen, ob uv installiert ist
    if not type -q uv
        echo "Fehler: 'uv' ist nicht installiert. Bitte installiere es zuerst."
        echo "Anleitung: https://github.com/astral-sh/uv"
        return 1
    end

    # Nach der Python-Version fragen
    read -P "Welche Python-Version? (z.B. 3.11, oder leer lassen für Standard): " py_version

    # Befehl zusammenbauen
    set -l cmd "uv venv"
    if test -n "$py_version"
        set cmd "$cmd -p python$py_version"
    end

    # Befehl ausführen
    echo "Führe aus: $cmd"
    eval $cmd

    # Prüfen, ob die Erstellung erfolgreich war
    if test $status -eq 0
        echo "Virtuelle Umgebung '.venv' wurde erfolgreich erstellt."
        # Umgebung direkt aktivieren
        if test -f .venv/bin/activate.fish
            source .venv/bin/activate.fish
            echo "Umgebung wurde aktiviert."
        end
    else
        echo "Fehler beim Erstellen der virtuellen Umgebung."
        return 1
    end
end
