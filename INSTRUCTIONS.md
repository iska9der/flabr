## Конфигурация

1. Создать файл `.env.prod` в корне проекта. Пример можно посмотреть в `.env.example`
2. Сгенерировать код
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

## Сборка

apk
```bash
sh scripts/build.sh env=prod --no-runner
```

```
--env - определяет окружение для сборки
--no-runner - пропустить запуск build_runner
```

###### Тестирование deeplink через терминал

Android
```bash
adb shell am start -a android.intent.action.VIEW -d "<URI>"
```

IOS
```bash
/usr/bin/xcrun simctl openurl booted "<URI>"
```