# Java configuration
set -gx JAVA_HOME (/usr/libexec/java_home -v 21)

if test -d $JAVA_HOME/bin
    fish_add_path -g -p $JAVA_HOME/bin
end
