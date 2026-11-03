#!/usr/bin/env bash
# Build the macOS release and zip the .app bundle.
# Run this ON macOS, with Xcode command-line tools installed — Flutter
# cannot cross-compile macOS desktop builds from Linux or Windows.
#
# Usage: scripts/build_macos.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

APP_NAME="myreportbd-desktop"
VERSION="$(grep '^version:' pubspec.yaml | sed 's/version: *//' | cut -d+ -f1)"

echo "==> flutter build macos --release"
flutter build macos --release

APP_BUNDLE="$(find "$ROOT/build/macos/Build/Products/Release" -maxdepth 1 -name '*.app' | head -1)"
if [[ -z "$APP_BUNDLE" ]]; then
  echo "No .app bundle found in build/macos/Build/Products/Release" >&2
  exit 1
fi

DIST_DIR="$ROOT/dist"
mkdir -p "$DIST_DIR"
ZIP_PATH="$DIST_DIR/${APP_NAME}-${VERSION}-macos.zip"

echo "==> Zipping $APP_BUNDLE"
rm -f "$ZIP_PATH"
ditto -c -k --sequesterRsrc --keepParent "$APP_BUNDLE" "$ZIP_PATH"

echo "    -> $ZIP_PATH"
echo "Note: this is unsigned and not notarized. Users will need to right-click >"
echo "Open the first time (Gatekeeper), or you'll need to codesign + notarize"
echo "separately with an Apple Developer account before wider distribution."
