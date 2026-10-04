# fnm (Fast Node Manager) environment setup
if command -q fnm
    set -q XDG_STATE_HOME; or set -gx XDG_STATE_HOME "$HOME/.local/state"
    mkdir -p "$XDG_STATE_HOME"
    fnm env --use-on-cd --version-file-strategy=recursive --shell fish --resolve-engines --corepack-enabled | source
end
