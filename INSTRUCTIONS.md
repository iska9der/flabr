## Конфигурация

1. Создать файл `.env.prod` в корне проекта. Пример можно посмотреть в `.env.example`
2. Сгенерировать код
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    # или
    sh scripts/runner.sh --runner
    ```

## Сборка

**apk**
```bash
sh scripts/build.sh env=prod --no-runner

# --env - определяет окружение для сборки
# --no-runner - пропустить запуск build_runner
```


## Управление версией

```bash
# Показать доступные команды
sh scripts/version.sh

# Увеличить patch версию и build номер (например: 1.2.4+10703 -> 1.2.5+10704)
sh scripts/version.sh --up

# Увеличить только build номер (например: 1.2.4+10703 -> 1.2.4+10704)
sh scripts/version.sh --build

# Установить и обновить версию Flutter через FVM
# Команда выполняет:
# 1. fvm install <версия>
# 2. Обновляет .fvmrc
# 3. Обновляет pubspec.yaml (environment.flutter)
sh scripts/version.sh flutter=3.35.6
```

##### Тестирование deeplink через терминал

Android
```bash
adb shell am start -a android.intent.action.VIEW -d "<URI>"
```

IOS
```bash
/usr/bin/xcrun simctl openurl booted "<URI>"
```