flutter pub get
# flutter pub run build_runner build --delete-conflicting-outputs

FLABRVER=$(yq -r '.version' 'pubspec.yaml' | cut -d '+' -f 1)
echo
echo "Make release builds for v$FLABRVER"
echo '--------------------------'

echo
echo "Android: build"
echo '--------------------------'
flutter build apk --release --split-per-abi --dart-define-from-file .env

rm -rf release
mkdir release

cp build/app/outputs/flutter-apk/app-release.apk release/flabr_v${FLABRVER}.apk
cp build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk release/flabr_v${FLABRVER}_armeabi-v7a.apk
cp build/app/outputs/flutter-apk/app-arm64-v8a-release.apk release/flabr_v${FLABRVER}_arm64-v8a.apk
cp build/app/outputs/flutter-apk/app-x86_64-release.apk release/flabr_v${FLABRVER}_x86_64.apk

echo
echo "Android: done"

# echo
# echo "Web: build"
# echo '--------------------------'
# flutter build web --release --dart-define-from-file .env
# cp -R build/web release/web/

# echo
# echo "Web: done"