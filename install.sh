#!/usr/bin/env bash
# Installs the Blue Archive theme for KDE Plasma 6 into the current user's profile.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"
LNF_ID="com.kivotos.bluearchive"
WALLPAPER_SVG="$SRC/wallpapers/KivotosSky/contents/images/3840x2160.svg"
APPLY_LAYOUT="ask"
APPLY_THEME="yes"

usage() {
    cat <<EOF
Usage: ./install.sh [--layout | --no-layout] [--no-apply]

  --layout      Replace your panels with the Blue Archive home-screen layout without asking
  --no-layout   Keep your current panels (colours, style, splash and wallpaper still change)
  --no-apply    Only install the files; don't switch anything
EOF
}

for arg in "$@"; do
    case "$arg" in
        --layout) APPLY_LAYOUT="yes" ;;
        --no-layout) APPLY_LAYOUT="no" ;;
        --no-apply) APPLY_THEME="no" ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown option: $arg" >&2; usage; exit 1 ;;
    esac
done

if ! command -v kpackagetool6 >/dev/null 2>&1; then
    echo "kpackagetool6 not found. This theme needs KDE Plasma 6." >&2
    exit 1
fi

step() { printf '\n\033[1;36m==>\033[0m %s\n' "$*"; }

install_pkg() {
    local type="$1" dir="$2"
    kpackagetool6 -t "$type" -u "$dir" >/dev/null 2>&1 || kpackagetool6 -t "$type" -i "$dir"
}

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

step "Colour scheme"
install -Dm644 "$SRC/color-schemes/BlueArchive.colors" "$DATA/color-schemes/BlueArchive.colors"

step "Plasma style"
mkdir -p "$DATA/plasma/desktoptheme"
rm -rf "$DATA/plasma/desktoptheme/BlueArchive"
cp -r "$SRC/plasma-style/BlueArchive" "$DATA/plasma/desktoptheme/BlueArchive"

step "Wallpaper"
WP="$DATA/wallpapers/KivotosSky"
mkdir -p "$DATA/wallpapers"
rm -rf "$WP"
cp -r "$SRC/wallpapers/KivotosSky" "$WP"
WP_IMAGE="$WP/contents/images/3840x2160.svg"
if command -v rsvg-convert >/dev/null 2>&1; then
    rsvg-convert -w 3840 -h 2160 "$WALLPAPER_SVG" -o "$WP/contents/images/3840x2160.png"
    rsvg-convert -w 400 -h 225 "$WALLPAPER_SVG" -o "$WP/contents/screenshot.png"
    rm "$WP_IMAGE"
    WP_IMAGE="$WP/contents/images/3840x2160.png"
else
    echo "  rsvg-convert not found; installing the SVG wallpaper as-is (install librsvg for a PNG copy)."
fi

step "Widgets"
for pkg in "$SRC"/plasmoids/*/; do
    echo "  - $(basename "$pkg")"
    install_pkg Plasma/Applet "$pkg"
done

step "Global theme"
cp -r "$SRC/global-theme/$LNF_ID" "$TMP/$LNF_ID"
if command -v rsvg-convert >/dev/null 2>&1; then
    mkdir -p "$TMP/$LNF_ID/contents/previews"
    rsvg-convert -w 640 -h 360 "$WALLPAPER_SVG" -o "$TMP/$LNF_ID/contents/previews/preview.png"
fi
install_pkg Plasma/LookAndFeel "$TMP/$LNF_ID"

if [ "$APPLY_THEME" = "yes" ]; then
    if [ "$APPLY_LAYOUT" = "ask" ]; then
        if [ -t 0 ]; then
            echo
            read -r -p "Replace your panels with the Blue Archive home-screen layout? Existing panels and desktop widgets will be removed. [y/N] " reply
            case "$reply" in
                [yY]*) APPLY_LAYOUT="yes" ;;
                *) APPLY_LAYOUT="no" ;;
            esac
        else
            APPLY_LAYOUT="no"
        fi
    fi

    step "Applying"
    if [ "$APPLY_LAYOUT" = "yes" ]; then
        plasma-apply-lookandfeel --apply "$LNF_ID" --resetLayout
    else
        plasma-apply-lookandfeel --apply "$LNF_ID"
    fi
    plasma-apply-colorscheme BlueArchive >/dev/null 2>&1 || true
    plasma-apply-desktoptheme BlueArchive >/dev/null 2>&1 || true
    plasma-apply-wallpaperimage "$WP_IMAGE" >/dev/null 2>&1 || true
fi

cat <<EOF

Done. Welcome back, Sensei!

If a widget shows an old version, restart Plasma:
    systemctl --user restart plasma-plasmashell
EOF
