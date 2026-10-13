#!/usr/bin/env bash
# Removes the Blue Archive theme and switches back to Breeze.
set -uo pipefail

DATA="${XDG_DATA_HOME:-$HOME/.local/share}"

if command -v plasma-apply-lookandfeel >/dev/null 2>&1; then
    echo "==> Switching back to Breeze"
    plasma-apply-lookandfeel --apply org.kde.breeze.desktop || true
fi

echo "==> Removing widgets and global theme"
for id in com.kivotos.shittimchest com.kivotos.senseiprofile com.kivotos.resources; do
    kpackagetool6 -t Plasma/Applet -r "$id" >/dev/null 2>&1 || true
done
kpackagetool6 -t Plasma/LookAndFeel -r com.kivotos.bluearchive >/dev/null 2>&1 || true

echo "==> Removing colour scheme, Plasma style and wallpaper"
rm -f "$DATA/color-schemes/BlueArchive.colors"
rm -rf "$DATA/plasma/desktoptheme/BlueArchive"
rm -rf "$DATA/wallpapers/KivotosSky"

cat <<EOF

Done. Panels created by the Blue Archive layout are still there; remove them in Edit Mode,
or reset to the stock Breeze layout with:
    plasma-apply-lookandfeel --apply org.kde.breeze.desktop --resetLayout
EOF
