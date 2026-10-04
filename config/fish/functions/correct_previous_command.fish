function correct_previous_command --description "Korrigiert den letzten Befehl mit thefuck"
    if type -q thefuck
        thefuck
    else
        echo "thefuck nicht installiert"
        return 1
    end
end
