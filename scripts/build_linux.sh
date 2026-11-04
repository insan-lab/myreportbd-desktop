#!/usr/bin/env bash
# Build the Linux release and package it for Debian-based (.deb) and/or
# Arch-based (.pkg.tar.zst) distros. Run this ON a Linux machine — Flutter
# cannot cross-compile desktop builds from another OS.
#
# Usage: scripts/build_linux.sh [--deb] [--arch] [--all]
#   No flags = package for whichever of dpkg-deb/makepkg is available.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

APP_NAME="myreportbd-desktop"   # package/install-dir name (kebab-case, distro convention)
BINARY_NAME="myreportbd_desktop" # actual executable name, from pubspec.yaml's `name:`
APP_DISPLAY_NAME="MyReportBD"
VERSION="$(grep '^version:' pubspec.yaml | sed 's/version: *//' | cut -d+ -f1)"
BUNDLE_DIR="$ROOT/build/linux/x64/release/bundle"
DIST_DIR="$ROOT/dist"

DO_DEB=0
DO_ARCH=0
for arg in "$@"; do
  case "$arg" in
    --deb) DO_DEB=1 ;;
    --arch) DO_ARCH=1 ;;
    --all) DO_DEB=1; DO_ARCH=1 ;;
    *) echo "Unknown flag: $arg" >&2; exit 1 ;;
  esac
done
if [[ $DO_DEB -eq 0 && $DO_ARCH -eq 0 ]]; then
  command -v dpkg-deb >/dev/null 2>&1 && DO_DEB=1
  command -v makepkg >/dev/null 2>&1 && DO_ARCH=1
fi
if [[ $DO_DEB -eq 0 && $DO_ARCH -eq 0 ]]; then
  echo "Neither dpkg-deb nor makepkg found; building the raw bundle only." >&2
fi

echo "==> flutter build linux --release"
flutter build linux --release

mkdir -p "$DIST_DIR"

package_deb() {
  echo "==> Packaging .deb"
  local pkgroot
  pkgroot="$(mktemp -d)"
  local installdir="$pkgroot/opt/$APP_NAME"
  mkdir -p "$installdir" "$pkgroot/DEBIAN" "$pkgroot/usr/share/applications" "$pkgroot/usr/bin" \
    "$pkgroot/usr/share/icons/hicolor/256x256/apps"
  cp -r "$BUNDLE_DIR"/* "$installdir/"
  ln -s "/opt/$APP_NAME/$BINARY_NAME" "$pkgroot/usr/bin/$APP_NAME"
  cp "$ROOT/linux/runner/resources/app_icon.png" \
    "$pkgroot/usr/share/icons/hicolor/256x256/apps/$APP_NAME.png"

  cat > "$pkgroot/DEBIAN/control" <<EOF
Package: $APP_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: amd64
Depends: libgtk-3-0, libsqlite3-0
Maintainer: $APP_DISPLAY_NAME
Description: $APP_DISPLAY_NAME desktop app
EOF

  cat > "$pkgroot/usr/share/applications/$APP_NAME.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=$APP_DISPLAY_NAME
Exec=/opt/$APP_NAME/$BINARY_NAME
Icon=$APP_NAME
Categories=Office;
EOF

  dpkg-deb --build --root-owner-group "$pkgroot" "$DIST_DIR/${APP_NAME}_${VERSION}_amd64.deb"
  rm -rf "$pkgroot"
  echo "    -> $DIST_DIR/${APP_NAME}_${VERSION}_amd64.deb"
}

package_arch() {
  echo "==> Packaging Arch package"
  local pkgdir
  pkgdir="$(mktemp -d)"
  cp -r "$BUNDLE_DIR" "$pkgdir/bundle"
  cp "$ROOT/linux/runner/resources/app_icon.png" "$pkgdir/app_icon.png"

  cat > "$pkgdir/PKGBUILD" <<EOF
pkgname=$APP_NAME
pkgver=$VERSION
pkgrel=1
pkgdesc="$APP_DISPLAY_NAME desktop app"
arch=('x86_64')
depends=('gtk3' 'sqlite')
options=('!strip')

package() {
  install -d "\$pkgdir/opt/$APP_NAME"
  cp -r "$pkgdir/bundle/." "\$pkgdir/opt/$APP_NAME/"
  install -d "\$pkgdir/usr/bin"
  ln -s "/opt/$APP_NAME/$BINARY_NAME" "\$pkgdir/usr/bin/$APP_NAME"
  install -Dm644 "app_icon.png" "\$pkgdir/usr/share/icons/hicolor/256x256/apps/$APP_NAME.png"
  install -Dm644 /dev/stdin "\$pkgdir/usr/share/applications/$APP_NAME.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=$APP_DISPLAY_NAME
Exec=/opt/$APP_NAME/$BINARY_NAME
Icon=$APP_NAME
Categories=Office;
DESKTOP
}
EOF

  (cd "$pkgdir" && makepkg --force)
  cp "$pkgdir"/*.pkg.tar.* "$DIST_DIR/"
  rm -rf "$pkgdir"
  echo "    -> $(ls "$DIST_DIR"/*.pkg.tar.* | tail -1)"
}

[[ $DO_DEB -eq 1 ]] && package_deb
[[ $DO_ARCH -eq 1 ]] && package_arch

echo "==> Bundle also available unpackaged at: $BUNDLE_DIR"
