# ccache fuer native iOS-Builds (React Native / CocoaPods)
# USE_CCACHE=1 wird von node_modules/react-native/scripts/cocoapods/utils.rb ausgelesen
# und muss gesetzt sein, weil ios/Podfile.properties.json bei jedem `expo prebuild`
# neu generiert wird (ios/ ist gitignored) und damit persistente Podfile-Properties nicht haelt.
set -gx USE_CCACHE 1
