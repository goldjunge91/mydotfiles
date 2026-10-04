# Java configuration
if test -x /usr/libexec/java_home
    set -l java_home (/usr/libexec/java_home -v 21 2>/dev/null)
    if test -n "$java_home" -a -d "$java_home/bin"
        set -gx JAVA_HOME $java_home
        fish_add_path -g -p $JAVA_HOME/bin
    end
end
