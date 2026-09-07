#!/bin/sh
set -eu

usage() {
  echo 'Usage: sh scripts/update_screenshots.sh <android-device-id> [OPTIONS]'
  echo ''
  echo 'Options:'
  echo '  --locales LIST    Comma-separated source locales; default: all configured'
  echo '  --scenarios LIST  Comma-separated scenario numbers; default: all configured'
  echo '  --help            Show this help'
}

if [ "${1:-}" = '--help' ]; then
  usage
  exit 0
fi
if [ "$#" -lt 1 ] || [ -z "$1" ]; then
  usage >&2
  exit 2
fi
case "$1" in
  --*)
    usage >&2
    exit 2
    ;;
esac

device=$1
shift
locales=
scenarios=
while [ "$#" -gt 0 ]; do
  case "$1" in
    --locales)
      if [ "$#" -lt 2 ] || [ -z "$2" ]; then
        echo 'Option --locales requires a value.' >&2
        exit 2
      fi
      locales=$2
      shift 2
      ;;
    --scenarios)
      if [ "$#" -lt 2 ] || [ -z "$2" ]; then
        echo 'Option --scenarios requires a value.' >&2
        exit 2
      fi
      scenarios=$2
      shift 2
      ;;
    --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done
repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_root"

# Обычная установка Flabr и её данные не затрагиваются
package=ru.iska9der.flabr.demo.debug
adb -s "$device" get-state
if [ "$(adb -s "$device" shell pm list packages "$package" | tr -d '\r')" = "package:$package" ]; then
  adb -s "$device" shell pm clear "$package"
fi

mkdir -p build
staging=$(mktemp -d "$repo_root/build/store-screenshots.XXXXXX")
trap 'rm -rf "$staging"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
SCREENSHOT_DIR=$staging
if command -v cygpath >/dev/null 2>&1; then
  SCREENSHOT_DIR=$(cygpath -m "$staging")
fi
export SCREENSHOT_DIR SCREENSHOT_LOCALES="$locales" SCREENSHOT_SCENARIOS="$scenarios"

# Готовый APK сохраняет правильный applicationId при запуске и удалении через drive
.fvm/flutter_sdk/bin/flutter build apk \
  --profile \
  --target=integration_test/store_screenshots_test.dart \
  --dart-define=ENV=demo \
  --dart-define=SCREENSHOT_LOCALES="$locales" \
  --dart-define=SCREENSHOT_SCENARIOS="$scenarios"

.fvm/flutter_sdk/bin/flutter drive \
  --profile \
  --no-pub \
  --use-application-binary=build/app/outputs/flutter-apk/app-profile.apk \
  --device-id="$device" \
  --driver=test_driver/store_screenshots_driver.dart \
  --target=integration_test/store_screenshots_test.dart

# Драйвер проверяет выбранный комплект до замены соответствующих PNG
for image in "$staging"/*/*.png; do
  [ -f "$image" ] || continue
  locale=$(basename "$(dirname "$image")")
  destination="fastlane/metadata/android/$locale/images/phoneScreenshots"
  mkdir -p "$destination"
  mv "$image" "$destination/$(basename "$image")"
done
printf 'Updated selected screenshots in fastlane/metadata/android/\n'
