# fnm (Fast Node Manager) environment setup
if command -q fnm
    fnm env --use-on-cd --version-file-strategy=recursive --shell fish --resolve-engines --corepack-enabled | source
end
