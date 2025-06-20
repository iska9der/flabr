## Конфигурация

1. Создать файл `.env.prod` в корне проекта. Пример можно посмотреть в `.env.example`

## Сборка

apk
```
sh scripts/build.sh env=prod --no-runner
```

```
--env - определяет окружение для сборки
--no-runner - пропустить запуск build_runner
```

###### Тестирование deeplink через терминал

Android
```
adb shell am start -a android.intent.action.VIEW -d "<URI>"
```

IOS
```
/usr/bin/xcrun simctl openurl booted "<URI>"
```