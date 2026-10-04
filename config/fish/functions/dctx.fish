function dctx --description 'Docker Context-Manager zum Wechseln oder Auflisten von Kontexten'
    if not type -q docker
        echo "Error: docker ist nicht installiert."
        return 1
    end

    if test (count $argv) -eq 0
        # Ohne Argument: Kontexte auflisten
        docker context ls
    else
        # Mit Argument: Kontext wechseln
        docker context use "$argv[1]"
    end
end
