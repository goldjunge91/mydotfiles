function current_shell --description "Zeigt den Pfad zur aktuellen Shell"
    type -p fish 2>/dev/null; or echo $SHELL
end
