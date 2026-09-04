# Publication Flows in Flabr

## Purpose

A flow identifies the thematic section used to filter the publication list. The application catalog is synchronized with the Habr navigation menu documented in the [upstream API reference](../api/publication-flows-menu.md).

## Model

The catalog is declared in `PublicationFlow`:

```text
lib/data/model/publication/publication_flow_enum.dart
```

Each entry contains:

- a Dart name in `lowerCamelCase`;
- an `alias` used by the Habr API and URLs;
- a localized user-facing label.

The Dart name is not used as an external identifier. For example:

```dart
PublicationFlow.mobileDevelopment.alias == 'mobile_development'
PublicationFlow.aiAndMl.alias == 'ai_and_ml'
```

This separation preserves Dart naming conventions without transforming values at the API boundary.

`PublicationFlow.all` represents the unfiltered publication list. Its requests omit the `flow` parameter.

## Alias conversion

Incoming route parameters are converted by `PublicationFlow.fromString`. Matching uses `PublicationFlow.alias`; an unknown value produces a `ValueException` with the `unknownPublicationFlow` type.

The value follows this path:

1. the publication list page receives an alias from the `flow` route parameter;
2. `PublicationFlow.fromString` converts the alias to an enum value;
3. `FlowPublicationListCubit` stores the selected flow in its state;
4. `PublicationRepository` passes the flow to `PublicationService`;
5. `PublicationServiceImpl.fetchFlowArticles` writes `PublicationFlow.alias` to the `flow` query parameter of the `/v2/articles/` request.

## Grouping

`PublicationFlowGroup` defines the UI sections and flow order:

1. `developmentAndEngineering` — development and engineering;
2. `infrastructureAndData` — infrastructure and data;
3. `management` — management;
4. `creativeAndPromotion` — creative and promotion;
5. `scienceAndLife` — science and life.

Each section’s members are stored in `PublicationFlowGroup.flows`. Concatenating all group lists must equal `PublicationFlow.values` except for the first `all` entry.

## Localization

Source labels are stored in:

```text
lib/i18n/ru.i18n.json
lib/i18n/en.i18n.json
```

Flow labels belong to `publication.flow`; group labels belong to `publication.flow.group`. After changing these catalogs, regenerate the Slang API:

```bash
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs
```

## Filter UI

`PublicationFiltersWidget` uses `PublicationFlow` and `PublicationFlowGroup` as
the source of truth for available choices and their order. The flow selector is
collapsed by default to keep the filter sheet compact and can be expanded when
the complete catalog is needed. If the active flow belongs to a hidden group,
the selector opens expanded so the current selection remains visible.

`CommonFiltersWidget` provides the sorting and secondary filter options. Applying
the form updates `FlowPublicationListCubit` and closes the sheet.

Relevant implementation:

```text
lib/presentation/page/publications/widget/publication_filters_widget.dart
lib/feature/publication_list/widget/floating_filter_button.dart
```

## Verification

Alias contracts and group ordering are covered by:

```text
test/publication_list/publication_flow_test.dart
```

After changing the flow catalog, run:

```bash
.fvm/flutter_sdk/bin/dart format <changed-dart-files>
.fvm/flutter_sdk/bin/flutter analyze
.fvm/flutter_sdk/bin/flutter test test/publication_list/publication_flow_test.dart
```
