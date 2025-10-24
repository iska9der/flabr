#!/bin/bash

show_help() {
  echo "Использование: sh scripts/runner.sh [ОПЦИЯ]"
  echo ""
  echo "Доступные опции:"
  echo "  --runner    Запустить build_runner для генерации кода"
  echo "  --icons     Сгенерировать иконки приложения"
  echo "  --splash    Сгенерировать splash screen"
  echo ""
  echo "Примеры:"
  echo "  sh scripts/runner.sh --runner"
  echo "  sh scripts/runner.sh --icons"
  echo "  sh scripts/runner.sh --splash"
}

case "$1" in
  --runner)
    dart run build_runner build --delete-conflicting-outputs
    ;;
  --icons)
    dart run flutter_launcher_icons -f flutter_launcher_icons.yaml
    ;;
  --splash)
    dart run flutter_native_splash:create flutter_native_splash.yaml
    ;;
  *)
    show_help
    exit 1
    ;;
esac
