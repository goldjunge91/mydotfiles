# 40-utils.fish - Abbreviation tips & utility settings
# Formatted according to conf-d-template.fish

function check_command -d "Prüft ob ein Befehl/Tool installiert ist" -a command
    if not type -q $command
        echo "check_command: $command ist nicht installiert."
        return 1
    end
    return 0
end

set -g ABBR_TIPS_PROMPT "\n⚡ \e[1;36m{{ .abbr }}\e[0m ⟹ {{ .cmd }}"
set -g ABBR_TIPS_ALIAS_WHITELIST "ls" "ll" "la" "grep"
set -g ABBR_TIPS_REGEXES '(^(\w+\s+)+(-{1,2})\w+)(\s\S+)' '(^( ?\w+){3}).*' '(^( ?\w+){2}).*' '(^( ?\w+){1}).*'
