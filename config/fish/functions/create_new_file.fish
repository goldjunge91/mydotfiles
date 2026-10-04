function create_new_file --description "Erstellt eine neue Datei mit interaktiver Namenseingabe"
    read -P "Dateiname: " filename
    if test -n "$filename"
        touch "$filename"
        echo "Datei '$filename' erstellt."
    else
        echo "Kein Dateiname angegeben. Abgebrochen."
    end
end
