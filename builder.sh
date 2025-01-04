flutter pub get

flutter pub run build_runner build --delete-conflicting-outputs

flutter build apk --release --split-per-abi --dart-define-from-file env/variables.json