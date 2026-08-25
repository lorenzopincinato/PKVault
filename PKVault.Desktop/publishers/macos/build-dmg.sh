#!/bin/sh

set -e

# Build a drag-to-Applications PKVault.dmg from an existing PKVault.app (also
# runs on Linux, no real Mac required).
# Usage: ./build-dmg.sh <version> <app-dir> <output-dir>

VERSION="${1:-dev}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="${2:-$SCRIPT_DIR/../../../out/PKVault.app}"
OUT_DIR="${3:-$SCRIPT_DIR/../../../out}"
DMG_PATH="$OUT_DIR/pkvault-$VERSION.dmg"

echo "=== Building pkvault-$VERSION.dmg ==="

STAGING_DIR=$(mktemp -d)/dmg-root
mkdir -p "$STAGING_DIR"
cp -r "$APP_DIR" "$STAGING_DIR/PKVault.app"
ln -s /Applications "$STAGING_DIR/Applications"

rm -f "$DMG_PATH"

if command -v hdiutil >/dev/null 2>&1; then
  hdiutil create -volname PKVault -srcfolder "$STAGING_DIR" -ov -format UDZO "$DMG_PATH"
else
  genisoimage -V PKVault -D -R -apple -no-pad -o "$DMG_PATH" "$STAGING_DIR"
fi

rm -rf "$(dirname "$STAGING_DIR")"

echo "=== pkvault-$VERSION.dmg created at $DMG_PATH ==="
