function theme_preview --description "Zeigt eine Vorschau der aktuellen Farbeinstellungen"
    echo
    echo "=== Theme-Vorschau: $__current_theme ==="
    echo

    # Kommando-Beispiele
    set_color $fish_color_command
    echo -n "ls -la"
    set_color normal
    echo -n " "
    set_color $fish_color_param
    echo -n "--color=auto"
    set_color normal
    echo -n " "
    set_color $fish_color_quote
    echo -n "\"~/Documents\""
    set_color normal
    echo

    # Kommentar-Beispiel
    set_color $fish_color_comment
    echo "# Dies ist ein Kommentar"
    set_color normal

    # Pfad-Beispiel
    set_color $fish_color_cwd
    echo -n "~/current/path"
    set_color normal
    echo " → "
    set_color $fish_color_valid_path --underline
    echo "/valid/path"
    set_color normal

    # Operator und Umleitung
    set_color $fish_color_command
    echo -n "cat"
    set_color normal
    echo -n " file.txt "
    set_color $fish_color_redirection
    echo -n ">"
    set_color normal
    echo -n " output.txt "
    set_color $fish_color_operator
    echo "&&"
    set_color normal
    echo -n " "
    set_color $fish_color_command
    echo "echo"
    set_color normal
    echo -n " "
    set_color $fish_color_quote
    echo "\"Fertig!\""
    set_color normal

    # Fehler-Beispiel
    set_color $fish_color_error
    echo "Fehler: Datei nicht gefunden"
    set_color normal

    # Escape-Sequenz
    set_color $fish_color_command
    echo -n "echo"
    set_color normal
    echo -n " "
    set_color $fish_color_quote
    echo -n "\""
    set_color $fish_color_escape
    echo -n "\\n\\t"
    set_color $fish_color_quote
    echo -n "Text"
    set_color $fish_color_quote
    echo "\""
    set_color normal

    echo
    echo "=========================="
    echo
end
