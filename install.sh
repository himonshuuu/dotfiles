#!/usr/bin/env bash
# Links every top-level folder in this repo into ~/.config.
# Safe to run repeatedly; anything already in the way is moved to <name>.bak.<timestamp>.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"

DRY=0
UNLINK=0
for arg in "$@"; do
    case "$arg" in
        -n|--dry-run) DRY=1 ;;
        --unlink)     UNLINK=1 ;;
        -h|--help)
            printf 'usage: %s [-n|--dry-run] [--unlink]\n' "$(basename "$0")"
            exit 0 ;;
        *) printf 'unknown option: %s\n' "$arg" >&2; exit 2 ;;
    esac
done

run() {
    if [ "$DRY" -eq 1 ]; then printf '  would  %s\n' "$1"; else eval "$1"; fi
}

link_one() {
    local src=$1 name=$2 dst="$CONFIG/$2"

    if [ "$UNLINK" -eq 1 ]; then
        if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
            run "rm '$dst'"
            printf '  unlinked %s\n' "$name"
        else
            printf '  skipped  %s (not managed by this repo)\n' "$name"
        fi
        return
    fi

    if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
        printf '  ok       %s\n' "$name"
        return
    fi

    if [ -e "$dst" ]; then
        local bak="$dst.bak.$(date +%Y%m%d%H%M%S)"
        run "mv '$dst' '$bak'"
        printf '  backup   %s -> %s\n' "$name" "$(basename "$bak")"
    fi

    run "ln -s '$src' '$dst'"
    printf '  linked   %s\n' "$name"
}

mkdir -p "$CONFIG"

found=0
for src in "$DOTFILES"/*/; do
    [ -e "$src" ] || continue
    name="$(basename "$src")"
    found=1
    link_one "${src%/}" "$name"
done

[ "$found" -eq 1 ] || { echo "no folders found in $DOTFILES" >&2; exit 1; }

if [ "$UNLINK" -eq 1 ]; then
    printf '\ndone - links removed\n'
elif [ "$DRY" -eq 1 ]; then
    printf '\ndry run - nothing changed\n'
else
    printf '\ndone - restart quickshell to pick up changes: pkill -x quickshell; qs\n'
fi
