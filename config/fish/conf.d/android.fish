# Android SDK configuration
set -gx ANDROID_HOME $HOME/Library/Android/sdk

if test -d $ANDROID_HOME
    fish_add_path -g -p $ANDROID_HOME/emulator $ANDROID_HOME/platform-tools
end
