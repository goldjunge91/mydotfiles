# 21-python-venv.fish - Automatic Python venv activation hook
# Formatted according to conf-d-template.fish

function __auto_python_venv --on-variable PWD -d "Automatische Aktivierung von Python venv"
    set -l subdirs (find . -mindepth 1 -maxdepth 1 -type d 2>/dev/null)

    for item in $subdirs
        set -l dir_name (string replace './' '' $item)
        set -l venv_path "$dir_name/bin/activate.fish"

        if test -f "$venv_path"
            set -l full_venv_path (pwd)/$dir_name

            if test "$VIRTUAL_ENV" != "$full_venv_path"
                source $venv_path
            end
            return
        end
    end

    if set -q VIRTUAL_ENV
        set -l project_path (dirname "$VIRTUAL_ENV")
        if not string match -q "$project_path*" (pwd)
            if type -q deactivate
                deactivate
            end
        end
    end
end

# Ensure python and pip aliases exist when python3/pip3 are available
if type -q python3; and not type -q python
    alias python=python3
end

if type -q pip3; and not type -q pip
    alias pip=pip3
end
