function cheat --description "Interaktive, farbige TUI-Oberfläche für alle eigenen Shell-Befehle, Plugins und Shortcuts"
    if not type -q fzf
        echo "Error: fzf ist nicht installiert."
        return 1
    end

    set -l d '\$'
    set -l tab (printf "\t")
    set -l c_reset (set_color normal)
    set -l c_cmd (set_color brgreen --bold)
    set -l c_fd (set_color cyan --bold)
    set -l c_docker (set_color blue --bold)
    set -l c_py (set_color yellow --bold)
    set -l c_sys (set_color magenta --bold)
    set -l c_key (set_color red --bold)
    set -l c_plug (set_color bryellow --bold)

    set -l items \
        "fdf"$tab"$c_fd""[🔍 Dateisuche]""$c_reset"$tab"$c_cmd""fdf""$c_reset"$tab"Sucht Dateien nach Endung (z.B. fdf py src/)" \
        "fdo"$tab"$c_fd""[🔍 Dateisuche]""$c_reset"$tab"$c_cmd""fdo""$c_reset"$tab"Datei suchen & direkt im VS Code Editor öffnen" \
        "fdsize"$tab"$c_fd""[🔍 Dateisuche]""$c_reset"$tab"$c_cmd""fdsize""$c_reset"$tab"Große Dateien finden (z.B. fdsize 100M ~/Downloads)" \
        "fdnew"$tab"$c_fd""[🔍 Dateisuche]""$c_reset"$tab"$c_cmd""fdnew""$c_reset"$tab"Kürzlich geänderte Dateien finden (z.B. fdnew 1d)" \
        "fda"$tab"$c_fd""[🔍 Dateisuche]""$c_reset"$tab"$c_cmd""fda""$c_reset"$tab"Alle Dateien durchsuchen (inkl. .git & versteckte)" \
        "fdcount"$tab"$c_fd""[🔍 Dateisuche]""$c_reset"$tab"$c_cmd""fdcount""$c_reset"$tab"Anzahl passender Dateien zählen" \
        "fddup"$tab"$c_fd""[🔍 Dateisuche]""$c_reset"$tab"$c_cmd""fddup""$c_reset"$tab"Dateien mit identischem Namen finden" \
        "fdt"$tab"$c_fd""[🔍 Dateisuche]""$c_reset"$tab"$c_cmd""fdt""$c_reset"$tab"Dateiinhalte mit fd + ripgrep durchsuchen" \
        "fdbackup"$tab"$c_fd""[🔍 Dateisuche]""$c_reset"$tab"$c_cmd""fdbackup""$c_reset"$tab"Sicherheits-Backup einer Datei erstellen" \
        "dctx"$tab"$c_docker""[🐳 Docker]""$c_reset"$tab"$c_cmd""dctx""$c_reset"$tab"Docker-Kontext auflisten oder wechseln" \
        "mkvenv"$tab"$c_py""[🐍 Python]""$c_reset"$tab"$c_cmd""mkvenv""$c_reset"$tab"Neue Python venv mit uv erstellen & aktivieren" \
        "uv"$tab"$c_py""[🐍 Python]""$c_reset"$tab"$c_cmd""uv""$c_reset"$tab"Ultraschnelle Python-Paketverwaltung (uv pip, uv run)" \
        "python"$tab"$c_py""[🐍 Python]""$c_reset"$tab"$c_cmd""python / pip""$c_reset"$tab"Python 3.14 Interpreter & Pip Paketmanager" \
        "z_top"$tab"$c_sys""[🌐 Navigation]""$c_reset"$tab"$c_cmd""z_top""$c_reset"$tab"Top 10 meistbesuchte Ordner anzeigen" \
        "z_clean"$tab"$c_sys""[🌐 Navigation]""$c_reset"$tab"$c_cmd""z_clean""$c_reset"$tab"Nicht existierende Pfade aus Zoxide löschen" \
        "z_import_all"$tab"$c_sys""[🌐 Navigation]""$c_reset"$tab"$c_cmd""z_import_all""$c_reset"$tab"Daten aus fasd, autojump, z.lua importieren" \
        "z_jump_menu"$tab"$c_sys""[🌐 Navigation]""$c_reset"$tab"$c_cmd""z_jump_menu""$c_reset"$tab"Interaktives Ordner-Menü aufrufen" \
        "create_new_file"$tab"$c_sys""[🛠️ System]""$c_reset"$tab"$c_cmd""create_new_file""$c_reset"$tab"Neue Datei interaktiv anlegen" \
        "rename_file"$tab"$c_sys""[🛠️ System]""$c_reset"$tab"$c_cmd""rename_file""$c_reset"$tab"Datei interaktiv mit FZF umbenennen" \
        "dbc"$tab"$c_sys""[🌐 Browser]""$c_reset"$tab"$c_cmd""dbc""$c_reset"$tab"Chrome als macOS Standard-Browser setzen" \
        "dbs"$tab"$c_sys""[🌐 Browser]""$c_reset"$tab"$c_cmd""dbs""$c_reset"$tab"Safari als macOS Standard-Browser setzen" \
        "fuck"$tab"$c_sys""[🛠️ System]""$c_reset"$tab"$c_cmd""fuck""$c_reset"$tab"Letzten fehlgeschlagenen Befehl korrigieren" \
        "current_shell"$tab"$c_sys""[🛠️ System]""$c_reset"$tab"$c_cmd""current_shell""$c_reset"$tab"Pfad zur aktuellen Shell anzeigen" \
        "theme_preview"$tab"$c_sys""[🛠️ System]""$c_reset"$tab"$c_cmd""theme_preview""$c_reset"$tab"Vorschau des aktuellen Fish Farb-Themes" \
        "fisher"$tab"$c_plug""[🔌 Plugin]""$c_reset"$tab"$c_cmd""fisher""$c_reset"$tab"Fish Plugin-Manager (Pakete verwalten)" \
        "bax"$tab"$c_plug""[🔌 Plugin]""$c_reset"$tab"$c_cmd""bax""$c_reset"$tab"Bash-Syntax & Skripte in Fish ausführen" \
        "colored_man_pages"$tab"$c_plug""[🔌 Plugin]""$c_reset"$tab"$c_cmd""man <befehl>""$c_reset"$tab"Farbige man-Dokumentation im Terminal" \
        "done"$tab"$c_plug""[🔌 Plugin]""$c_reset"$tab"$c_cmd""done""$c_reset"$tab"Desktop-Benachrichtigung bei langen Befehlen" \
        "bang-bang"$tab"$c_plug""[🔌 Plugin]""$c_reset"$tab"$c_cmd""bang-bang (!! / !"$d")""$c_reset"$tab"Bash !! und !"$d" Shortcuts in Fish" \
        "you_should_use"$tab"$c_plug""[🔌 Plugin]""$c_reset"$tab"$c_cmd""you_should_use (YSU)""$c_reset"$tab"Alias-Erinnerungs-Plugin" \
        "fnm"$tab"$c_plug""[🔌 Plugin]""$c_reset"$tab"$c_cmd""fnm""$c_reset"$tab"Fast Node Manager (Node.js Versionen)" \
        "fifc"$tab"$c_plug""[🔌 Plugin]""$c_reset"$tab"$c_cmd""fifc""$c_reset"$tab"Fish Interactive Fuzzy Completion" \
        "fzf_plugin"$tab"$c_plug""[🔌 Plugin]""$c_reset"$tab"$c_cmd""fzf.fish""$c_reset"$tab"FZF Integration & Keybindings" \
        "fig"$tab"$c_plug""[🔌 Plugin]""$c_reset"$tab"$c_cmd""fig (00_fig / 99_fig)""$c_reset"$tab"Amazon Q / Fig Autocomplete Hook" \
        "fifc-small"$tab"$c_sys""[🔤 FIFC]""$c_reset"$tab"$c_cmd""fifc-small""$c_reset"$tab"Vorschau-Textgröße auf Klein stellen" \
        "fifc-medium"$tab"$c_sys""[🔤 FIFC]""$c_reset"$tab"$c_cmd""fifc-medium""$c_reset"$tab"Vorschau-Textgröße auf Mittel stellen" \
        "fifc-large"$tab"$c_sys""[🔤 FIFC]""$c_reset"$tab"$c_cmd""fifc-large""$c_reset"$tab"Vorschau-Textgröße auf Groß stellen" \
        "fifc-xl"$tab"$c_sys""[🔤 FIFC]""$c_reset"$tab"$c_cmd""fifc-xl""$c_reset"$tab"Vorschau-Textgröße auf Extra Groß stellen" \
        "fifc-config"$tab"$c_sys""[🔤 FIFC]""$c_reset"$tab"$c_cmd""fifc-config""$c_reset"$tab"FIFC Konfiguration anzeigen" \
        "Ctrl+R"$tab"$c_key""[⌨️ Shortcut]""$c_reset"$tab"$c_cmd""Ctrl+R""$c_reset"$tab"$c_key""[Pfeil-Hoch ↑]""$c_reset"$tab"Atuin TUI-History (SQLite, Zeit, Exit-Codes)" \
        "Option+H"$tab"$c_key""[⌨️ Shortcut]""$c_reset"$tab"$c_cmd""Option+H""$c_reset"$tab"FZF History-Suche mit Live-Syntaxhighlighting" \
        "Option+Z"$tab"$c_key""[⌨️ Shortcut]""$c_reset"$tab"$c_cmd""Option+Z""$c_reset"$tab"Zoxide Interaktives Verzeichnis-Menü" \
        "Option+Y"$tab"$c_key""[⌨️ Shortcut]""$c_reset"$tab"$c_cmd""Option+Y""$c_reset"$tab"FIFC Autovervollständigungs-Vorschau" \
        "Option+F"$tab"$c_key""[⌨️ Shortcut]""$c_reset"$tab"$c_cmd""Option+F""$c_reset"$tab"FZF Lokale Dateisuche im aktuellen Ordner" \
        "Option+G"$tab"$c_key""[⌨️ Shortcut]""$c_reset"$tab"$c_cmd""Option+G""$c_reset"$tab"FZF Globale Dateisuche im Home-Ordner" \
        "Option+D"$tab"$c_key""[⌨️ Shortcut]""$c_reset"$tab"$c_cmd""Option+D""$c_reset"$tab"FZF Ordner-Navigation" \
        "Option+P"$tab"$c_key""[⌨️ Shortcut]""$c_reset"$tab"$c_cmd""Option+P""$c_reset"$tab"FZF Prozesssuche & Beenden"

    set -l selected (printf "%s\n" $items | fzf \
        --ansi \
        --delimiter="\t" \
        --with-nth=2.. \
        --height 85% \
        --layout=reverse \
        --border=rounded \
        --prompt="⚡ Dashboard > " \
        --header="[ENTER] Befehl übernehmen | [ESC] Beenden" \
        --preview-window="right:60%:wrap" \
        --preview='
            set -l cmd {1}
            echo "╭──────────────────────────────────────────────────────────╮"
            echo "│ 🚀 DETAILS & PRAXIS-BEISPIELE: $cmd"
            echo "╰──────────────────────────────────────────────────────────╯"
            echo
            switch $cmd
                case fisher
                    echo "PLUGIN:       jorgebucaran/fisher"
                    echo "BESCHREIBUNG: Der Paket-Manager für die Fish-Shell zum Installieren & Verwalten von Plugins."
                    echo
                    echo "VERWENDUNG:"
                    echo "  fisher list                    -> Alle installierten Plugins auflisten"
                    echo "  fisher update                  -> Alle Plugins aktualisieren"
                    echo "  fisher install <autor/repo>    -> Neues Plugin installieren"
                    echo "  fisher remove <autor/repo>     -> Plugin deinstallieren"
                case bax
                    echo "PLUGIN:       jorgebucaran/bax.fish"
                    echo "BESCHREIBUNG: Führt Bash-Syntax, Umgebungsvariablen-Exporte & Shell-Skripte direkt in Fish aus."
                    echo
                    echo "BEISPIELE:"
                    echo "  1) bax \"export FOO=bar && echo \$FOO\""
                    echo "  2) bax \"source ~/.bashrc\""
                case colored_man_pages
                    echo "PLUGIN:       patrickf1/colored_man_pages.fish"
                    echo "BESCHREIBUNG: Färbt Handbuchseiten (man) im Terminal automatisch übersichtlich & farbig ein."
                    echo
                    echo "BEISPIELE:"
                    echo "  1) man ls   -> Zeigt das Handbuch für ls mit farbigem Syntax-Highlighting"
                    echo "  2) man git  -> Zeigt das Git-Handbuch farbig strukturiert"
                case done
                    echo "PLUGIN:       franciscolourenco/done (conf.d/done.fish)"
                    echo "BESCHREIBUNG: Sendet eine macOS Desktop-Benachrichtigung, wenn ein langer Befehl fertig ist."
                    echo "DETAILS:      Löst aus, wenn ein Befehl länger als 10 Sekunden gedauert hat."
                case bang-bang
                    echo "PLUGIN:       oh-my-fish/plugin-bang-bang (conf.d/plugin-bang-bang.fish)"
                    echo "BESCHREIBUNG: Bringt Bash-Shortcuts !! (letzter Befehl) und !"\$ " (letztes Argument) in Fish."
                    echo "BEISPIELE:"
                    echo "  1) !!  -> Fügt den kompletten vorherigen Befehl ein"
                    echo "  2) !"\$ " -> Fügt das letzte Argument des vorherigen Befehls ein"
                case you_should_use
                    echo "PLUGIN:       paysonwallach/fish-you-should-use (conf.d/you_should_use.fish)"
                    echo "BESCHREIBUNG: Erinnert dich im Terminal daran, definierte Aliase zu nutzen."
                case fnm
                    echo "PLUGIN:       conf.d/fnm.fish"
                    echo "BESCHREIBUNG: Smart-Loading für FNM (Fast Node Manager)."
                    echo "FUNKTIONEN:   Initialisiert Node/NPM/PNPM/Yarn/Bun erst bei Bedarf oder in Node-Projekten."
                case fifc
                    echo "PLUGIN:       gazorby/fifc (conf.d/fifc.fish)"
                    echo "BESCHREIBUNG: Interaktives FZF-Vorschaufenster für Tab-Autovervollständigungen."
                case fzf_plugin
                    echo "PLUGIN:       patrickf1/fzf.fish (conf.d/fzf.fish)"
                    echo "BESCHREIBUNG: Tastenkombinationen & Hilfsfunktionen für FZF Suchmenüs."
                case fig
                    echo "PLUGIN:       conf.d/00_fig_pre.fish & conf.d/99_fig_post.fish"
                    echo "BESCHREIBUNG: Terminal-Integration für Fig / Amazon Q Autocomplete."
                case fdf
                    echo "BESCHREIBUNG:"
                    echo "  Sucht Dateien gezielt nach Dateiendung (ohne Punkte)."
                    echo
                    echo "VERWENDUNG:"
                    echo "  fdf <erweiterung> [suchpfad]"
                    echo
                    echo "BEISPIELE:"
                    echo "  1) fdf py"
                    echo "     Findet alle .py Dateien im aktuellen Ordner."
                    echo
                    echo "  2) fdf json ~/.config"
                    echo "     Findet alle .json Dateien im Ordner ~/.config."
                    echo
                    echo "  3) fdf md ~/Documents"
                    echo "     Findet alle Markdown-Dokumente unter ~/Documents."
                case fdo
                    echo "BESCHREIBUNG:"
                    echo "  Sucht eine Datei & öffnet sie sofort im VS Code Editor."
                    echo
                    echo "VERWENDUNG:"
                    echo "  fdo <suchmuster> [suchpfad]"
                    echo
                    echo "BEISPIELE:"
                    echo "  1) fdo main.py ."
                    echo "     Öffnet main.py aus dem aktuellen Ordner in VS Code."
                    echo
                    echo "  2) fdo config ~/.config"
                    echo "     Sucht nach config-Dateien und öffnet sie."
                case fdsize
                    echo "BESCHREIBUNG:"
                    echo "  Findet Dateien, die größer als die angegebene Speichergröße sind."
                    echo
                    echo "VERWENDUNG:"
                    echo "  fdsize <größe> [suchpfad]"
                    echo
                    echo "EINHEITEN:"
                    echo "  - 10M  -> 10 Megabyte"
                    echo "  - 500M -> 500 Megabyte"
                    echo "  - 1G   -> 1 Gigabyte"
                    echo
                    echo "BEISPIELE:"
                    echo "  1) fdsize 100M ~/Downloads"
                    echo "     Zeigt alle Downloads größer als 100 MB an."
                    echo
                    echo "  2) fdsize 1G /"
                    echo "     Findet riesige Dateien über 1 GB auf dem gesamten System."
                case fdnew
                    echo "BESCHREIBUNG:"
                    echo "  Findet Dateien, die kürzlich innerhalb von Zeitraum geändert wurden."
                    echo
                    echo "VERWENDUNG:"
                    echo "  fdnew <zeitspanne> [suchpfad]"
                    echo
                    echo "ZEITSPANNEN:"
                    echo "  - 10m    -> Letzte 10 Minuten"
                    echo "  - 2h     -> Letzte 2 Stunden"
                    echo "  - 1d     -> Letzte 24 Stunden (1 Tag)"
                    echo "  - 1week  -> Letzte Woche"
                    echo
                    echo "BEISPIELE:"
                    echo "  1) fdnew 2h"
                    echo "     Findet in den letzten 2 Stunden geänderte Dateien im Ordner."
                    echo
                    echo "  2) fdnew 1d ~/Projects"
                    echo "     Findet in den letzten 24h geänderte Dateien in ~/Projects."
                case fda
                    echo "BESCHREIBUNG:"
                    echo "  Durchsucht ALLE Dateien – inklusive versteckter Dotfiles & .git."
                    echo
                    echo "VERWENDUNG:"
                    echo "  fda <suchmuster> [suchpfad]"
                    echo
                    echo "BEISPIELE:"
                    echo "  1) fda .env ."
                    echo "     Findet versteckte Umgebungsdateien (.env)."
                    echo
                    echo "  2) fda config ~/.config"
                    echo "     Durchsucht alle versteckten Konfigurationsordner."
                case fdcount
                    echo "BESCHREIBUNG:"
                    echo "  Zählt die genaue Anzahl passender Dateien im Pfad."
                    echo
                    echo "VERWENDUNG:"
                    echo "  fdcount <suchmuster> [suchpfad]"
                    echo
                    echo "BEISPIELE:"
                    echo "  1) fdcount \"*.py\" src/"
                    echo "     Zählt alle Python-Dateien im Ordner src."
                    echo
                    echo "  2) fdcount \"*.png\" ~/Pictures"
                    echo "     Zählt alle PNG-Bilder in ~/Pictures."
                case fddup
                    echo "BESCHREIBUNG:"
                    echo "  Spürt Dateien auf, die denselben Dateinamen tragen (Namensduplikate)."
                    echo
                    echo "VERWENDUNG:"
                    echo "  fddup [suchpfad]"
                    echo
                    echo "BEISPIELE:"
                    echo "  1) fddup ."
                    echo "     Sucht doppelte Dateinamen im aktuellen Projekt."
                    echo
                    echo "  2) fddup ~/Documents"
                    echo "     Findet doppelte Dateinamen unter ~/Documents."
                case fdt
                    echo "BESCHREIBUNG:"
                    echo "  Sucht nach Textinhalten in Dateien mit fd + ripgrep."
                    echo
                    echo "VERWENDUNG:"
                    echo "  fdt <suchtext> [dateimuster] [suchpfad]"
                    echo
                    echo "DATEIMUSTER (Wildcards & Endungen):"
                    echo "  - \"*.py\"      -> Nur in Python-Dateien suchen"
                    echo "  - \"*.json\"    -> Nur in JSON-Dateien suchen"
                    echo "  - \"*.fish\"    -> Nur in Fish-Shell Skripten suchen"
                    echo "  - \"config*\"   -> In Dateien suchen, die mit config beginnen"
                    echo
                    echo "BEISPIELE:"
                    echo "  1) fdt \"import os\""
                    echo "     Sucht \"import os\" in allen Dateien im aktuellen Ordner."
                    echo
                    echo "  2) fdt \"TODO\" \"*.py\""
                    echo "     Sucht \"TODO\" nur in Python-Dateien (*.py)."
                    echo
                    echo "  3) fdt \"function\" \"*.fish\" ~/.config/fish"
                    echo "     Sucht \"function\" in allen Fish-Skripten im Pfad ~/.config/fish."
                case fdbackup
                    echo "BESCHREIBUNG:"
                    echo "  Erstellt eine Backup-Kopie einer Datei mit automatischem Zeitstempel."
                    echo
                    echo "VERWENDUNG:"
                    echo "  fdbackup <dateiname> [suchpfad]"
                    echo
                    echo "BEISPIEL:"
                    echo "  fdbackup config.fish"
                    echo "  -> Erstellt z.B. config.fish.backup_20260811_190900"
                case dctx
                    echo "BESCHREIBUNG:"
                    echo "  Docker Context Manager zum Auflisten & Wechseln des Kontextes."
                    echo
                    echo "VERWENDUNG:"
                    echo "  dctx [kontext_name]"
                    echo
                    echo "BEISPIELE:"
                    echo "  1) dctx"
                    echo "     Listet alle registrierten Docker-Kontexte auf."
                    echo
                    echo "  2) dctx desktop-linux"
                    echo "     Schaltet Docker auf den Kontext desktop-linux um."
                case mkvenv
                    echo "BESCHREIBUNG:"
                    echo "  Erstellt mit uv eine schnelle Python venv & aktiviert sie sofort."
                    echo
                    echo "VERWENDUNG:"
                    echo "  mkvenv [python_version]"
                    echo
                    echo "BEISPIELE:"
                    echo "  1) mkvenv"
                    echo "     Erstellt Standard Python-Umgebung in .venv"
                    echo
                    echo "  2) mkvenv 3.12"
                    echo "     Erstellt Python 3.12 venv in .venv"
                case uv
                    echo "BESCHREIBUNG:"
                    echo "  Extrem schneller Python Paket- & Projektmanager (Astral uv)."
                    echo
                    echo "WICHTIGE BEFEHLE:"
                    echo "  1) uv pip install <paket>      -> Paket blitzschnell installieren"
                    echo "  2) uv run script.py            -> Skript direkt ausführen"
                    echo "  3) uv venv                     -> Neue virtuelle Umgebung erstellen"
                    echo "  4) uv python install 3.12      -> Spezifische Python-Version nachladen"
                    echo "  5) uv python list              -> Alle verfügbaren Python-Versionen"
                case python
                    echo "BESCHREIBUNG:"
                    echo "  Aktives Python 3.14.3 Setup & Pip Paketverwaltung."
                    echo
                    echo "VERWENDUNG:"
                    echo "  python --version               -> Aktuelle Version anzeigen (3.14.3)"
                    echo "  pip list                       -> Installierte Pakete anzeigen"
                    echo "  python main.py                 -> Python-Skript starten"
                case z_top
                    echo "BESCHREIBUNG:"
                    echo "  Zeigt die Top 10 am häufigsten besuchten Zoxide-Ordner."
                    echo "VERWENDUNG: z_top"
                case z_clean
                    echo "BESCHREIBUNG:"
                    echo "  Bereinigt die Zoxide-Datenbank von nicht mehr existierenden Pfaden."
                    echo "VERWENDUNG: z_clean"
                case z_import_all
                    echo "BESCHREIBUNG:"
                    echo "  Importiert Ordner-Daten aus fasd, autojump, z.lua in Zoxide."
                    echo "VERWENDUNG: z_import_all"
                case z_jump_menu
                    echo "BESCHREIBUNG:"
                    echo "  Interaktives Ordner-Menü mit Vorschau (Alt+Z)."
                    echo "VERWENDUNG: z_jump_menu"
                case dbc
                    echo "BESCHREIBUNG: Setzt Google Chrome als macOS Standard-Browser."
                    echo "VERWENDUNG:   dbc"
                case dbs
                    echo "BESCHREIBUNG: Setzt Apple Safari als macOS Standard-Browser."
                    echo "VERWENDUNG:   dbs"
                case fuck
                    echo "BESCHREIBUNG: Korrigiert den letzten fehlerhaften Befehl via thefuck."
                    echo "VERWENDUNG:   fuck"
                    echo
                    echo "BEISPIEL:"
                    echo "  puthon script.py -> Tippe \"fuck\" -> python script.py"
                case create_new_file
                    echo "BESCHREIBUNG: Fragt interaktiv nach einem Dateinamen & erstellt die Datei."
                    echo "VERWENDUNG:   create_new_file"
                case rename_file
                    echo "BESCHREIBUNG: Wählt eine Datei per FZF aus & benennt sie um."
                    echo "VERWENDUNG:   rename_file"
                case current_shell
                    echo "BESCHREIBUNG: Zeigt den Pfad zur aktuellen Shell-Executable an."
                    echo "VERWENDUNG:   current_shell"
                case theme_preview
                    echo "BESCHREIBUNG: Zeigt eine Testausgabe aller Farben deines Farb-Themes."
                    echo "VERWENDUNG:   theme_preview"
                case fifc-small
                    echo "BESCHREIBUNG: Setzt FIFC Vorschau-Textgröße auf Klein"
                case fifc-medium
                    echo "BESCHREIBUNG: Setzt FIFC Vorschau-Textgröße auf Mittel"
                case fifc-large
                    echo "BESCHREIBUNG: Setzt FIFC Vorschau-Textgröße auf Groß"
                case fifc-xl
                    echo "BESCHREIBUNG: Setzt FIFC Vorschau-Textgröße auf Extra Groß"
                case fifc-config
                    echo "BESCHREIBUNG: Zeigt FIFC- & FZF-Konfiguration an"
                case Ctrl+R
                    echo "TASTE:    Control ⌃ + R oder Pfeil-Hoch ↑"
                    echo "FUNKTION: Atuin SQLite Befehlshistorie mit Ausführungszeit, Exit-Codes & Ordner-Filter."
                case Option+H
                    echo "TASTE:    Option ⌥ + H"
                    echo "FUNKTION: FZF History-Suche mit farbigem Syntax-Highlighting."
                case Option+Z
                    echo "TASTE:    Option ⌥ + Z"
                    echo "FUNKTION: Zoxide Ordner-Picker mit Ordnerinhalts-Vorschau."
                case Option+Y
                    echo "TASTE:    Option ⌥ + Y"
                    echo "FUNKTION: FIFC Autovervollständigung mit Live-Vorschau."
                case Option+F
                    echo "TASTE:    Option ⌥ + F"
                    echo "FUNKTION: FZF Lokale Dateisuche mit bat-Vorschau."
                case Option+G
                    echo "TASTE:    Option ⌥ + G"
                    echo "FUNKTION: FZF Globale Dateisuche im Home-Verzeichnis."
                case Option+D
                    echo "TASTE:    Option ⌥ + D"
                    echo "FUNKTION: FZF Verzeichnis-Navigation."
                case Option+P
                    echo "TASTE:    Option ⌥ + P"
                    echo "FUNKTION: FZF Prozess-Manager (Prozesse durchsuchen & beenden)."
                case "*"
                    echo "Hilfsbefehl für deine Fish-Shell."
            end
        '
    )

    if test -n "$selected"
        set -l cmd (string split $tab -- $selected)[1]
        if not string match -q "*+*" "$cmd"
            commandline -r "$cmd "
        end
    end
end
