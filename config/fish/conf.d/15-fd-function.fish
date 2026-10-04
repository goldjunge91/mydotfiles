# 15-fd-function.fish - fd utilities & fnm integration
# Formatted according to conf-d-template.fish

if not type -q fd
    exit 0
end

# Lazy wrapper functions
function fdf -d "Sucht Dateien mit bestimmter Erweiterung: fdf <--ext=js> [<--path=~/Projects>]"
    __fd_functions_lazy_init
    fdf $argv
end

function fdo -d "Findet Dateien und öffnet sie im Editor: fdo <--pattern=*.md> [<--path=~/Documents>]"
    __fd_functions_lazy_init
    fdo $argv
end

function fdsize -d "Findet Dateien größer als angegebene Größe: fdsize <--size=+100M> [<--path=~/Downloads>]"
    __fd_functions_lazy_init
    fdsize $argv
end

function fdnew -d "Findet Dateien geändert innerhalb Zeitraum: fdnew <--timespan=1d> [<--path=~/Projects>]"
    __fd_functions_lazy_init
    fdnew $argv
end

function fda -d "Durchsucht alle Dateien inkl. versteckte: fda <--pattern=config> [<--path=~/.config>]"
    __fd_functions_lazy_init
    fda $argv
end

function fdcount --description "Findet und zählt Dateien nach Typ oder Muster"
    __fd_functions_lazy_init
    fdcount $argv
end

function fddup --description "Findet Dateien mit gleichem Namen"
    __fd_functions_lazy_init
    fddup $argv
end

function fdt --description "Sucht nach Text in Dateien mit fd + rg"
    __fd_functions_lazy_init
    fdt $argv
end

# Lazy Loading Definitionen
function __fd_functions_lazy_init
    functions -e __fd_functions_lazy_init

    function fdf --description "Sucht Dateien mit bestimmter Erweiterung"
        if test (count $argv) -eq 0
            echo "Verwendung: fdf [Erweiterung] [Suchpfad (optional)]"
            return 1
        end

        set -l ext $argv[1]
        set -l search_path "."

        if test (count $argv) -gt 1
            set search_path $argv[2..-1]
        end

        fd -t f -e $ext . $search_path
    end

    function fdo --description "Finde Dateien und öffne sie im Editor"
        if test (count $argv) -eq 0
            echo "Verwendung: fdo [Suchmuster] [Pfad (optional)]"
            return 1
        end

        set -l pattern $argv[1]
        set -l search_path "."

        if test (count $argv) -gt 1
            set search_path $argv[2..-1]
        end

        set -l editor $EDITOR
        if test -z "$editor"
            set editor code
        end

        fd $pattern $search_path -X $editor
    end

    function fdsize --description "Findet Dateien größer als angegebene Größe"
        if test (count $argv) -lt 1
            echo "Verwendung: fdsize [Größe (z.B. 100M, 1G)] [Pfad (optional)]"
            return 1
        end

        set -l size $argv[1]
        set -l search_path "."

        if test (count $argv) -gt 1
            set search_path $argv[2..-1]
        end

        fd -t f --size +$size . $search_path
    end

    function fdnew --description "Findet Dateien, die innerhalb des angegebenen Zeitraums geändert wurden"
        if test (count $argv) -lt 1
            echo "Verwendung: fdnew [Zeitraum (z.B. 2h, 1d, 1week)] [Pfad (optional)]"
            return 1
        end

        set -l timespan $argv[1]
        set -l search_path "."

        if test (count $argv) -gt 1
            set search_path $argv[2..-1]
        end

        fd -t f --changed-within $timespan . $search_path
    end

    function fda --description "Durchsucht alle Dateien (inkl. versteckte und ignorierte)"
        set -l pattern ""
        set -l search_path "."

        if test (count $argv) -ge 1
            set pattern $argv[1]

            if test (count $argv) -gt 1
                set search_path $argv[2..-1]
            end
        end

        if test -z "$pattern"
            set pattern "."
        end

        fd -HI $pattern $search_path
    end

    function fdcount --description "Findet und zählt Dateien nach Typ oder Muster"
        if test (count $argv) -eq 0
            echo "Verwendung: fdcount [Muster/Erweiterung] [Pfad (optional)]"
            return 1
        end

        set -l pattern $argv[1]
        set -l search_path "."

        if test (count $argv) -gt 1
            set search_path $argv[2..-1]
        end

        set -l total (fd -t f $pattern $search_path | count)
        echo "Gefundene Dateien für '$pattern' in $search_path: $total"
    end

    function fddup --description "Findet Dateien mit gleichem Namen"
        set -l search_path "."
        if test (count $argv) -ge 1
            set search_path $argv[1]
        end
        fd -t f . $search_path | awk -F'/' '{print $NF}' | sort | uniq -d
    end

    function fdt --description "Sucht nach Text in Dateien mit fd + rg"
        if not command -q rg
            echo "Diese Funktion benötigt ripgrep (rg). Bitte installieren Sie es zuerst."
            return 1
        end

        if test (count $argv) -lt 1
            echo "Verwendung: fdt [Textmuster] [Dateisuche (optional)] [Pfad (optional)]"
            return 1
        end

        set -l text_pattern $argv[1]
        set -l file_pattern ""
        set -l search_path "."

        if test (count $argv) -gt 1
            set file_pattern $argv[2]

            if test (count $argv) -gt 2
                set search_path $argv[3..-1]
            end
        end

        if test -n "$file_pattern"
            fd -t f $file_pattern $search_path -X rg -l $text_pattern
        else
            fd -t f . $search_path -X rg -l $text_pattern
        end
    end
end

# FIFC Textgröße-Optionen
function fifc_text_size_small --description "Setzt kleine Textgröße für fifc"
    set -gx fifc_bat_opts --style=plain --color=always --line-range :50 --wrap=character --tabs=2
    set -gx FZF_DEFAULT_OPTS '--height 60% --layout=reverse --border --preview-window=right:45%:wrap --bind=ctrl-/:toggle-preview'
    echo "🔤 FIFC Textgröße: Klein"
end

function fifc_text_size_medium --description "Setzt mittlere Textgröße für fifc"
    set -gx fifc_bat_opts --style=numbers --color=always --line-range :100 --wrap=character --tabs=4
    set -gx FZF_DEFAULT_OPTS '--height 70% --layout=reverse --border --preview-window=right:50%:wrap --bind=ctrl-/:toggle-preview'
    echo "🔤 FIFC Textgröße: Mittel"
end

function fifc_text_size_large --description "Setzt große Textgröße für fifc"
    set -gx fifc_bat_opts --style=numbers,header --color=always --line-range :80 --wrap=character --tabs=4
    set -gx FZF_DEFAULT_OPTS '--height 80% --layout=reverse --border --preview-window=right:60%:wrap --bind=ctrl-/:toggle-preview --margin=1,2'
    echo "🔤 FIFC Textgröße: Groß"
end

function fifc_text_size_extra_large --description "Setzt extra große Textgröße für fifc"
    set -gx fifc_bat_opts --style=header,grid --color=always --line-range :60 --wrap=character --tabs=6
    set -gx FZF_DEFAULT_OPTS '--height 90% --layout=reverse --border --preview-window=right:65%:wrap --bind=ctrl-/:toggle-preview --margin=2,4'
    echo "🔤 FIFC Textgröße: Extra Groß"
end

function fifc_show_config --description "Zeigt aktuelle fifc Textgröße-Konfiguration"
    echo "🔧 Aktuelle FIFC Konfiguration:"
    echo "   BAT Optionen: $fifc_bat_opts"
    echo "   FZF Optionen: $FZF_DEFAULT_OPTS"
    echo ""
    echo "📝 Verfügbare Befehle:"
    echo "   fifc_text_size_small      - Kleine Textgröße"
    echo "   fifc_text_size_medium     - Mittlere Textgröße"
    echo "   fifc_text_size_large      - Große Textgröße"
    echo "   fifc_text_size_extra_large - Extra große Textgröße"
end

alias fifc-small='fifc_text_size_small'
alias fifc-medium='fifc_text_size_medium'
alias fifc-large='fifc_text_size_large'
alias fifc-xl='fifc_text_size_extra_large'
alias fifc-config='fifc_show_config'

# FNM (Node.js Version Manager) Smart Loading
if command -v fnm >/dev/null 2>&1
    set -gx FNM_DIR "$HOME/.local/share/fnm"
    fish_add_path "$HOME/.local/share/fnm/aliases/default/bin"

    function __fnm_smart_init -d "Initialisiert FNM nur bei Bedarf"
        if set -q __fnm_initialized
            return 0
        end
        set -g __fnm_initialized 1
        fnm env | source
    end

    function node; __fnm_smart_init; command node $argv; end
    function npm; __fnm_smart_init; command npm $argv; end
    function npx; __fnm_smart_init; command npx $argv; end
    function pnpm; __fnm_smart_init; command pnpm $argv; end
    function bun; __fnm_smart_init; command bun $argv; end
    function yarn; __fnm_smart_init; command yarn $argv; end

    function __fnm_auto_init --on-variable PWD -d "Auto-initialisiert FNM in Node.js Projekten"
        if test -f package.json; or test -f tsconfig.json; or test -f yarn.lock; or test -f pnpm-lock.yaml
            __fnm_smart_init
        end
    end
end

function fdbackup --description "Erstellt ein Backup einer Datei. Sucht mit max. Tiefe 5 oder im angegebenen Pfad."
    if test (count $argv) -lt 1
        echo "Verwendung: fdbackup [Dateiname] [Optionaler Suchpfad]"
        return 1
    end

    set -l filename $argv[1]
    set -l search_path "."
    set -l fd_opts ""

    if test (count $argv) -gt 1
        set search_path $argv[2]
        echo "Suche im angegebenen Pfad: $search_path"
    else
        set fd_opts "--max-depth 5"
        echo "Suche im aktuellen Verzeichnis (max. 5 Ebenen tief)."
    end

    set -l date_suffix (date +"%Y%m%d_%H%M%S")
    fd $fd_opts -t f -g "$filename" "$search_path" -x cp -v {} {}.backup_$date_suffix

    if test $status -ne 0
        echo "Keine Datei mit dem Namen '$filename' im Suchpfad gefunden."
    end
end
