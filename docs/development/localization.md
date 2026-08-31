# Локализация

## Обзор

Локализация приложения построена на `slang` и `slang_flutter`. Исходные переводы хранятся в JSON-каталогах, а типизированный Dart API генерируется через `slang_build_runner`.

Поддерживаемые языки интерфейса:

- русский (`ru`) — базовая локаль;
- английский (`en`).

Если в выбранной локали отсутствует перевод, Slang использует базовую русскую локаль согласно `fallback_strategy: base_locale`.

## Файлы

```text
lib/i18n/
├── i18n.dart               # публичный экспорт локализации
├── ru.i18n.json            # русский каталог и базовая структура ключей
├── en.i18n.json            # английский каталог
├── translations.g.dart     # общий сгенерированный Slang API
├── translations_ru.g.dart  # сгенерированный русский каталог
└── translations_en.g.dart  # сгенерированный английский каталог
```

Настройки генератора находятся в `build.yaml`:

```yaml
slang_build_runner:
  options:
    base_locale: ru
    fallback_strategy: base_locale
    input_directory: lib/i18n
    input_file_pattern: .i18n.json
    output_directory: lib/i18n
    output_file_name: translations.g.dart
    flutter_integration: true
    locale_handling: true
    lazy: false
    enum_name: AppLocale
    class_name: Translations
    translate_var: t
    key_case: camel
    key_map_case: camel
    string_interpolation: double_braces
    timestamp: false
```

Файлы `translations*.g.dart` генерируются Slang и вручную не редактируются.

## Структура каталогов

Оба каталога должны иметь одинаковую структуру. Русский каталог задаёт базовую локаль, но наличие fallback не заменяет перевод ключа в английском каталоге.

Ключи группируются по семантическому владельцу, затем по назначению. Плоские ключи с повторяющимися префиксами не используются.

Примеры текущей структуры:

```json
{
  "publication": {
    "complexity": {
      "easy": "Простой",
      "medium": "Средний",
      "hard": "Сложный"
    },
    "flow": {
      "development": "Разработка"
    },
    "format": {
      "caseStudy": "Кейс"
    }
  },
  "search": {
    "order": {
      "relevance": "По релевантности"
    }
  }
}
```

Такой каталог создаёт типизированные обращения:

```dart
t.publication.complexity.easy
t.publication.flow.development
t.publication.format.caseStudy
t.search.order.relevance
```

### Правила размещения ключей

1. Верхний уровень обозначает домен или пользовательскую область: `publication`, `user`, `tracker`, `search`, `settings`.
2. Вложенный объект объединяет один вид сущностей или сообщений: `publication.type`, `user.bookmarks.types`, `tracker.notifications`.
3. Листовой ключ описывает значение без повторения родительских имён: `publication.type.article`, а не `publication.type.publicationArticle`.
4. Заголовок объекта хранится в `title` или `label`, если рядом с ним находятся другие свойства объекта: `tracker.publications.title`, `summary.token.label`.
5. Ошибки группируются с операцией или сущностью: `company.profile.fetchFailed`, `summary.link.fetchError`.
6. Один смысл принадлежит одному домену. Одинаковый текст в разных доменах не является причиной переносить его в `common`.
7. Параметры интерполяции записываются через двойные фигурные скобки: `{{votesCount}}`.

## Использование в Dart

Публичная точка импорта:

```dart
import '../../i18n/i18n.dart';
```

Для кода, не зависящего от `BuildContext`, используется глобальный типизированный каталог `t`:

```dart
String get label => t.publication.type.article;
```

В widget-коде доступен каталог текущего контекста:

```dart
Text(context.t.tracker.publications.title)
```

Когда нужен сам объект переводов, он получается через provider:

```dart
final translations = Translations.of(context);
Text(translations.summary.token.label)
```

Интерполируемые ключи генерируются как функции с именованными параметрами:

```dart
t.user.list.votes(votesCount: count)
```

## Подключение к приложению

Корневой `Application` оборачивает приложение в `TranslationProvider`. Это делает Slang-каталог доступным всему widget tree и позволяет зависимым виджетам перестраиваться после смены локали.

Перечень языков приложения задаёт enum `Language`:

```dart
enum Language {
  ru,
  en;
}
```

`Language.appLocale` связывает доменную модель языка со сгенерированным `AppLocale`. `Language.locale` предоставляет Flutter/Intl locale.

Текущий язык интерфейса хранится через `LanguageRepository` в `CacheStorage` под ключом `CacheKeys.langUI`. Поток `LanguageRepository.onUIChange` обновляет `SettingsCubit`. Затем `GlobalBlocListener` синхронизирует:

- `LocaleSettings` Slang;
- `Intl.defaultLocale`;
- локализованные быстрые действия приложения.

Языки публикаций хранятся отдельно под `CacheKeys.langPublications`. Они влияют на параметры и cookie запросов к Habr, но не выбирают каталог интерфейса.

## Добавление и изменение переводов

1. Выбрать семантический домен и вложенную группу ключа.
2. Добавить одинаковый путь в `ru.i18n.json` и `en.i18n.json`.
3. Для нового языка добавить значение в `Language`, сопоставления `locale` и `appLocale`, а также соответствующий `.i18n.json` каталог.
4. Запустить генерацию:

```bash
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs
```

5. Использовать сгенерированный типизированный accessor вместо строкового ключа.
6. Отформатировать изменённые Dart-файлы и запустить анализатор:

```bash
.fvm/flutter_sdk/bin/dart format <changed-dart-files>
.fvm/flutter_sdk/bin/flutter analyze
```

## Проверки

Основные проверки локализации находятся в `test/i18n/localization_test.dart`. Они покрывают:

- соответствие `Language` и `AppLocale`;
- локализацию ошибок на presentation-слое;
- принадлежность ключей семантическим доменам;
- переключение каталога через `TranslationProvider`.

Запуск тестов локализации:

```bash
.fvm/flutter_sdk/bin/flutter test test/i18n/localization_test.dart
```

После изменения структуры ключей необходимо мигрировать все Dart callsites и перегенерировать Slang API. Старые accessor-ы не сохраняются как alias.
