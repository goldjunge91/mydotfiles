function ls --description 'ls with improved defaults'
    # -G Enable colorized output
    # -h When used with the -l option, use unit suffixes: Byte, Kilobyte etc.
    command ls -Gh $argv
end