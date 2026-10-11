#!/usr/bin/env bash
# Creates a new app from this foundation with its own package name, bundle id and display name.
#
#   ./scripts/new_project.sh ../my_app my_app com.acme.myapp "My App"
#   make new-project dest=../my_app pkg=my_app bundle=com.acme.myapp name="My App"
#
# The dev flavor automatically gets "<bundle>.dev" and "<name> Dev".
set -euo pipefail

if [[ $# -ne 4 ]]; then
  echo "Usage: $0 <destination_dir> <package_name> <bundle_id> \"<App Name>\"" >&2
  exit 1
fi

DEST="$1" NEW_PKG="$2" NEW_BUNDLE="$3" NEW_NAME="$4"

[[ "$NEW_PKG" =~ ^[a-z][a-z0-9_]*$ ]] || { echo "package_name must be snake_case: $NEW_PKG" >&2; exit 1; }
[[ "$NEW_BUNDLE" =~ ^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)+$ ]] || { echo "bundle_id must look like com.company.app: $NEW_BUNDLE" >&2; exit 1; }
[[ -e "$DEST" ]] && { echo "Destination already exists: $DEST" >&2; exit 1; }

SRC="$(cd "$(dirname "$0")/.." && pwd)"

# Read the current identifiers from the source project, so this script also
# works from any project that was itself created by it.
OLD_PKG="$(awk '/^name:/{print $2; exit}' "$SRC/pubspec.yaml")"
OLD_BUNDLE="$(sed -n 's/^ *namespace = "\(.*\)"/\1/p' "$SRC/android/app/build.gradle.kts")"
OLD_NAME="$(sed -n 's/^BUNDLE_DISPLAY_NAME=//p' "$SRC/ios/Flutter/prodRelease.xcconfig")"
echo "Template: $OLD_PKG | $OLD_BUNDLE | $OLD_NAME"
echo "New:      $NEW_PKG | $NEW_BUNDLE | $NEW_NAME"

rsync -a \
  --exclude .git --exclude build --exclude .dart_tool --exclude .idea --exclude '*.iml' \
  --exclude '.flutter-plugins*' --exclude ios/Pods --exclude ios/Podfile.lock \
  --exclude ios/Flutter/ephemeral --exclude ios/Flutter/Generated.xcconfig \
  --exclude ios/Flutter/flutter_export_environment.sh \
  --exclude android/.gradle --exclude android/.kotlin --exclude android/local.properties \
  --exclude .DS_Store \
  "$SRC/" "$DEST/"

cd "$DEST"

# Replace identifiers in every text file (most specific first).
export OLD_PKG NEW_PKG OLD_BUNDLE NEW_BUNDLE OLD_NAME NEW_NAME
grep -rlI --exclude-dir=scripts -e "$OLD_BUNDLE" -e "$OLD_NAME" -e "$OLD_PKG" . | while read -r f; do
  perl -pi -e '
    s/\Q$ENV{OLD_BUNDLE}\E/$ENV{NEW_BUNDLE}/g;
    s/\Q$ENV{OLD_NAME}\E/$ENV{NEW_NAME}/g;
    s/\b\Q$ENV{OLD_PKG}\E\b/$ENV{NEW_PKG}/g;
  ' "$f"
done

# Move MainActivity to the new Kotlin package directory.
KOTLIN=android/app/src/main/kotlin
OLD_DIR="$KOTLIN/${OLD_BUNDLE//.//}"
NEW_DIR="$KOTLIN/${NEW_BUNDLE//.//}"
if [[ "$OLD_DIR" != "$NEW_DIR" ]]; then
  mkdir -p "$NEW_DIR"
  mv "$OLD_DIR"/* "$NEW_DIR"/
  find "$KOTLIN" -type d -empty -delete
fi

FLUTTER="$(command -v fvm >/dev/null 2>&1 && echo 'fvm flutter' || echo 'flutter')"
DART="$(command -v fvm >/dev/null 2>&1 && echo 'fvm dart' || echo 'dart')"
$FLUTTER pub get
$DART run build_runner build --delete-conflicting-outputs
git init -q && git add -A && git commit -qm "Initial commit from Flutter foundation" || true

echo
echo "✓ Created $NEW_NAME at $DEST"
echo "  Next: update base URLs in lib/core/config/app_config.dart and brand colors in lib/core/theme/app_palette.dart"
echo "  Run:  cd $DEST && make run-dev"
