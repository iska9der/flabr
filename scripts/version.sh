#!/bin/bash

# Скрипт для увеличения версии flutter/приложения
# Использование:
#   ./scripts/version.sh                 - показать справку
#   ./scripts/version.sh --up            - увеличить версию (patch) и build
#   ./scripts/version.sh --build         - увеличить только build
#   ./scripts/version.sh flutter=3.35.6  - установить и обновить Flutter версию

# Проверяем параметры
UP_VERSION=false
BUILD_ONLY=false
FLUTTER_VERSION=""
for argument in "$@"
do
  key=$(echo $argument | cut --fields 1 --delimiter='=')
  value=$(echo $argument | cut --fields 2 --delimiter='=')

  case "$key" in
    "--up")
      UP_VERSION=true ;;
    "--build")
      BUILD_ONLY=true ;;
    "flutter")
      FLUTTER_VERSION="$value" ;;
    *) ;;
  esac
done

# Если параметры не указаны, выводим справку
if [ "$UP_VERSION" = false ] && [ "$BUILD_ONLY" = false ] && [ -z "$FLUTTER_VERSION" ]; then
  echo
  echo "Использование: sh scripts/version.sh [параметр]"
  echo
  echo "Параметры:"
  echo "  --up              Увеличить patch и build номер"
  echo "  --build           Увеличить только build номер"
  echo "  flutter=VERSION   Установить и обновить Flutter версию"
  echo
  echo "Примеры:"
  echo "  sh scripts/version.sh --up"
  echo "  sh scripts/version.sh --build"
  echo "  sh scripts/version.sh flutter=3.35.6"
  echo
  exit 0
fi

# Если нужно обновить Flutter версию
if [ -n "$FLUTTER_VERSION" ]; then
  # Читаем текущую версию Flutter из .fvmrc
  CURRENT_FLUTTER=$(grep '"flutter"' .fvmrc | sed 's/.*"flutter": *"\([^"]*\)".*/\1/')

  echo
  echo "Установка новой версии Flutter:"
  echo "  $CURRENT_FLUTTER -> $FLUTTER_VERSION"
  echo

  # Устанавливаем версию через fvm
  echo "Выполняем: fvm install $FLUTTER_VERSION"
  fvm install $FLUTTER_VERSION

  # Проверяем успешность установки
  if [ $? -ne 0 ]; then
    echo
    echo "✗ Ошибка установки Flutter через fvm"
    echo
    exit 1
  fi

  echo
  echo "Обновляем .fvmrc и pubspec.yaml..."

  # Обновляем .fvmrc
  sed "s/\"flutter\": *\"[^\"]*\"/\"flutter\": \"$FLUTTER_VERSION\"/" .fvmrc > .fvmrc.tmp
  mv .fvmrc.tmp .fvmrc

  # Обновляем pubspec.yaml
  sed "s/  flutter: .*/  flutter: $FLUTTER_VERSION/" pubspec.yaml > pubspec.yaml.tmp
  mv pubspec.yaml.tmp pubspec.yaml

  echo
  echo "✓ Flutter версия успешно обновлена!"
  echo
  exit 0
fi

# Если нужно увеличить версию или build
if [ "$UP_VERSION" = true ] || [ "$BUILD_ONLY" = true ]; then
  # Читаем текущую версию из pubspec.yaml
  CURRENT_VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: *//')

  # Разделяем версию и build number
  VERSION_PART=$(echo $CURRENT_VERSION | cut -d '+' -f 1)
  BUILD_PART=$(echo $CURRENT_VERSION | cut -d '+' -f 2)

  # Разбиваем версию на компоненты
  MAJOR=$(echo $VERSION_PART | cut -d '.' -f 1)
  MINOR=$(echo $VERSION_PART | cut -d '.' -f 2)
  PATCH=$(echo $VERSION_PART | cut -d '.' -f 3)

  # Увеличиваем build number
  NEW_BUILD=$((BUILD_PART + 1))

  # Формируем новую версию
  if [ "$BUILD_ONLY" = true ]; then
    # Только build number
    NEW_VERSION="$VERSION_PART+$NEW_BUILD"
    echo
    echo "Увеличиваем build:"
    echo "  $CURRENT_VERSION -> $NEW_VERSION"
  else
    # Увеличиваем patch и build
    NEW_PATCH=$((PATCH + 1))
    NEW_VERSION="$MAJOR.$MINOR.$NEW_PATCH+$NEW_BUILD"
    echo
    echo "Увеличиваем version + build:"
    echo "  $CURRENT_VERSION -> $NEW_VERSION"
  fi

  # Обновляем pubspec.yaml (создаем временный файл для совместимости с Windows/Unix)
  sed "s/^version: .*/version: $NEW_VERSION/" pubspec.yaml > pubspec.yaml.tmp
  mv pubspec.yaml.tmp pubspec.yaml

  echo
  echo "✓ Версия успешно обновлена!"
  echo
fi
