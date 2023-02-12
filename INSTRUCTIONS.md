## Pre-build

```
flutter pub get
```

```
if (Platform.isIOS)  {
    cd ios && pod install && cd ..
}
```

```
flutter pub run build_runner build --delete-conflicting-outputs
```

## Build

apk
```
flutter build apk --release --split-per-abi 
```

## Dev
###### Testing App Links

Android
```
adb shell am start -a android.intent.action.VIEW -d "<URI>"
```

IOS
```
/usr/bin/xcrun simctl openurl booted "<URI>"
```