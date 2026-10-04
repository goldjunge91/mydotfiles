# 15-meta-keys.fish - Terminal meta keys & FZF/FIFC search functions
# Formatted according to conf-d-template.fish

function enable_meta_keys --description "Aktiviert erweiterte Meta-Key Unterstützung für VS Code"
    if test "$TERM_PROGRAM" = vscode
        printf '\e[?1h\e='
        set -gx INPUTRC $HOME/.inputrc 2>/dev/null
    end
end

function test_meta_keys --description "Testet die Meta-Key Funktionalität"
    echo "Teste Meta-Key Kombinationen:"
    echo "- Alt+b: Wort zurück"
    echo "- Alt+f: Wort vorwärts"
    echo "- Alt+d: Wort löschen"
    echo "- Alt+Backspace: Wort rückwärts löschen"
    echo "- Alt+.: Letztes Argument wiederholen"
    echo ""
    echo "Drücken Sie eine Meta-Key Kombination zum Testen..."
end

if test "$TERM_PROGRAM" = vscode
    enable_meta_keys
end

if not type -q fzf
    exit 0
end

if status is-interactive
    set -gx FZF_DEFAULT_OPTS '--height 60% --layout=reverse --border --inline-info --ansi'

    if type -q fd
        set -gx FZF_DEFAULT_COMMAND 'fd --type file --color=always --exclude .git'
        set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
        set -gx FZF_ALT_C_COMMAND 'fd --type directory --color=always --exclude .git'
    end

    function fzf_history_search -d "Befehlshistorie-Suche mit FZF (Ctrl+H)"
        set -l result (history | fzf --height 60% --layout=reverse --border \
            --prompt="Command History: " \
            --preview 'echo {}' \
            --preview-window down:3:wrap)
        if test -n "$result"
            commandline $result
        end
        commandline -f repaint
    end

    function fzf_directory_search -d "Verzeichnis-Navigation mit FZF und Zoxide (Ctrl+D)"
        set -l result
        if type -q zoxide
            set result (zoxide query -l | fzf --height 60% --layout=reverse --border \
                --prompt="Recent Directories: " \
                --preview 'if type -q eza; eza --icons --tree --level=1 --git {}; else; ls -la {}; end')
        else if type -q fd
            set result (fd --type directory --color=always --hidden --exclude .git --max-depth 5 $HOME | fzf --height 60% --layout=reverse --border \
                --prompt="Directories: " \
                --preview 'if type -q eza; eza --icons --tree --level=1 --git {}; else; ls -la {}; end')
        else
            set result (find $HOME -type d -maxdepth 5 2>/dev/null | fzf --height 60% --layout=reverse --border \
                --prompt="Directories: " \
                --preview 'ls -la {}')
        end
        if test -n "$result"
            cd "$result"
        end
        commandline -f repaint
    end

    function fzf_process_search -d "Prozesssuche mit FZF (Alt+P)"
        set -l result
        if type -q procs
            set result (procs --color always | fzf --height 60% --layout=reverse --border \
                --prompt="Processes: " \
                --header-lines=1 \
                --preview 'echo "Process Details:" && procs --color always | grep {1}' \
                --preview-window down:5:wrap)
            if test -n "$result"
                set -l pid (echo $result | awk '{print $1}')
                if test -n "$pid"
                    echo "Beende Prozess $pid..."
                    kill -TERM $pid
                end
            end
        else
            set result (ps aux | fzf --height 60% --layout=reverse --border \
                --prompt="Processes: " \
                --header-lines=1 \
                --preview 'echo "PID: {2}" && echo "Command: {11}" && echo "CPU: {3}%" && echo "Memory: {4}%"' \
                --preview-window down:5:wrap)
            if test -n "$result"
                set -l pid (echo $result | awk '{print $2}')
                if test -n "$pid"
                    echo "Beende Prozess $pid..."
                    kill -TERM $pid
                end
            end
        end
        commandline -f repaint
    end
end

if functions -q fifc; and status is-interactive
    function fifc_local_search -d "Lokale Dateisuche mit FZF und Vorschau (Ctrl+F)"
        if functions -q __fifc_lazy_init
            __fifc_lazy_init
        end
        set -l current_dir (pwd)
        set -l result
        if type -q fd
            set result (fd . --type file --color=always --max-depth 3 --hidden --exclude .git $current_dir | fzf --height 60% --layout=reverse --border --preview 'if type -q bat; bat --color=always --style=numbers --line-range :100 --wrap=character {}; else; cat {}; end' --preview-window 'right,50%,wrap')
        else
            set result (find $current_dir -maxdepth 3 -type f | fzf --height 60% --layout=reverse --border --preview 'cat {}' --preview-window 'right,50%,wrap')
        end
        if test -n "$result"
            $EDITOR "$result"
        end
        commandline -f repaint
    end

    function fifc_global_search -d "Globale Dateisuche im Home-Verzeichnis mit FZF und Vorschau (Ctrl+G)"
        if functions -q __fifc_lazy_init
            __fifc_lazy_init
        end
        set -l result
        if type -q fd
            set result (fd . --type file --color=always --max-depth 8 --hidden --exclude .git $HOME | fzf --height 60% --layout=reverse --border --preview 'if type -q bat; bat --color=always --style=numbers --line-range :100 --wrap=character {}; else; cat {}; end' --preview-window 'right,50%,wrap')
        else
            set result (fd . --type file --color=always --max-depth 8 --hidden --exclude .git $HOME | fzf --height 60% --layout=reverse --border --preview 'if type -q bat; bat --color=always --style=numbers --line-range :100 --wrap=character {}; else; cat {}; end' --preview-window 'right,50%,wrap')
        end
        if test -n "$result"
            $EDITOR "$result"
        end
        commandline -f repaint
    end

    function __fifc_lazy_init -d "Initialisiert FIFC-Konfiguration verzögert"
        functions -e __fifc_lazy_init

        set -g fifc_editor $EDITOR
        if test -z "$fifc_editor"
            set -g fifc_editor code
        end
        set -g fifc_open_keybinding ctrl-o

        set -gx FZF_DEFAULT_OPTS '--height 70% --layout=reverse --border --preview-window=right:50%:wrap --bind=ctrl-/:toggle-preview --color=dark'

        if type -q bat
            set -g fifc_bat_opts --style=numbers,header,grid --color=always --line-range :100 --wrap=character --tabs=2 --theme=TwoDark
        end
        if type -q fd
            set -g fifc_fd_opts --hidden --follow --exclude .git --type f --max-depth 5
        end
        if type -q eza
            set -g fifc_exa_opts --icons --tree --level=1 --git
        end

        if test "$TERM_PROGRAM" = vscode
            set -gx FZF_DEFAULT_OPTS '--height 75% --layout=reverse --border --preview-window=right:55%:wrap --bind=ctrl-/:toggle-preview --color=dark --margin=1'
        else if test "$TERM_PROGRAM" = iTerm.app
            set -gx FZF_DEFAULT_OPTS '--height 85% --layout=reverse --border --preview-window=right:60%:wrap --bind=ctrl-/:toggle-preview --color=dark --margin=2'
        end

        fifc -n 'test -f "$fifc_candidate"' \
            -p 'if type -q bat; bat --color=always $fifc_bat_opts "$fifc_candidate"; else; cat "$fifc_candidate"; end' \
            -o '$fifc_editor "$fifc_candidate"'

        fifc -n 'functions -q -- "$fifc_candidate"' \
            -p 'functions -- "$fifc_candidate" | if type -q bat; bat --color=always --language fish $fifc_bat_opts; else; cat; end' \
            -o 'set -l func_path (functions -D "$fifc_candidate" | string match -r "Defined in (.+)$" | string replace -r "Defined in (.+)" "$1"); if test -f "$func_path"; $fifc_editor "$func_path"; else; echo "Funktionsdatei nicht gefunden: $func_path"; end'
    end
end

function _fifc_preview_file -d "Zeigt Dateivorschau für FIFC"
    if test -f "$fifc_candidate"
        if type -q bat
            bat --color=always $fifc_bat_opts "$fifc_candidate" 2>/dev/null
        else
            head -50 "$fifc_candidate" 2>/dev/null
        end
    else
        echo "Datei nicht gefunden: $fifc_candidate"
    end
end

function _fifc_preview_dir -d "Zeigt Verzeichnisvorschau für FIFC"
    if test -d "$fifc_candidate"
        if type -q eza
            eza $fifc_exa_opts "$fifc_candidate" 2>/dev/null
        else
            ls -la "$fifc_candidate" 2>/dev/null
        end
    else
        echo "Verzeichnis nicht gefunden: $fifc_candidate"
    end
end

function _fifc_open_file -d "Öffnet Datei im Editor für FIFC"
    if test -f "$fifc_candidate"
        $fifc_editor "$fifc_candidate"
    else
        echo "Datei kann nicht geöffnet werden: $fifc_candidate"
    end
end
