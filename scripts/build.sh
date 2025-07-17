FLABRVER=$(yq -r '.version' 'pubspec.yaml' | cut -d '+' -f 1)
ENV="prod"
SKIP_RUNNER=false

# Reading arguments
for argument in "$@"
do
  key=$(echo $argument | cut --fields 1 --delimiter='=')
  value=$(echo $argument | cut --fields 2 --delimiter='=')

  case "$key" in
    "env")
      ENV="$value" ;;
    "--no-runner")
      SKIP_RUNNER=true ;;
    *) ;;
  esac
done

echo
echo "Flabr v$FLABRVER [$ENV]"
echo '--------------------------'


echo
echo "Get dependencies"
echo '---'
flutter pub get

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo
  echo "Installing iOS dependencies via Pod"
  echo '---'
  cd ios && pod install && cd ..
fi

if [ "$SKIP_RUNNER" = false ]; then
echo
echo "Build dependencies"
echo '---'
flutter pub run build_runner build --delete-conflicting-outputs
fi

echo
echo "Android: build"
echo '--------------------------'
flutter build apk --release --split-per-abi --dart-define-from-file .env.$ENV

rm -rf release
mkdir release

# search for: Issue (universal)
# cp build/app/outputs/flutter-apk/app-release.apk release/flabr_v${FLABRVER}.apk
cp build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk release/flabr_v${FLABRVER}_armeabi-v7a.apk
cp build/app/outputs/flutter-apk/app-arm64-v8a-release.apk release/flabr_v${FLABRVER}_arm64-v8a.apk
cp build/app/outputs/flutter-apk/app-x86_64-release.apk release/flabr_v${FLABRVER}_x86_64.apk

echo
echo "Android: done"

# echo
# echo "Web: build"
# echo '--------------------------'
# flutter build web --release --dart-define-from-file .env.$env
# cp -R build/web release/web/

# echo
# echo "Web: done"