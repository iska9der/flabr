Flabr
===

Habra mobile client on Flutter


---
### Build

*apk:*
```
flutter build apk --release --split-per-abi 
```

---
### Testing app links

*Android:* 
```
adb shell am start -a android.intent.action.VIEW -d "<URI>"
```

*IOS:*
```
/usr/bin/xcrun simctl openurl booted "<URI>"
```
