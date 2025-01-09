flutter pub get

flutter pub run build_runner build --delete-conflicting-outputs

FLABRVER=$(yq -r '.version' 'pubspec.yaml' | cut -d '+' -f 1)
echo "Make release builds for v$FLABRVER"

flutter build apk --release --dart-define-from-file env/variables.json
flutter build apk --release --split-per-abi --dart-define-from-file env/variables.json

rm -rf release
mkdir release
cp build/app/outputs/flutter-apk/app-release.apk release/flabr_v${FLABRVER}.apk
cp build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk release/flabr_v${FLABRVER}_armeabi-v7a.apk
cp build/app/outputs/flutter-apk/app-arm64-v8a-release.apk release/flabr_v${FLABRVER}_arm64-v8a.apk
cp build/app/outputs/flutter-apk/app-x86_64-release.apk release/flabr_v${FLABRVER}_x86_64.apk