enum ScreenshotScreen { feed, newsFilters, reader, interfaceSettings }

class ScreenshotScenario {
  const ScreenshotScenario(this.id, this.screen);

  final int id;
  final ScreenshotScreen screen;
}

const screenshotScenarios = [
  ScreenshotScenario(1, ScreenshotScreen.feed),
  ScreenshotScenario(2, ScreenshotScreen.newsFilters),
  ScreenshotScenario(3, ScreenshotScreen.reader),
  ScreenshotScenario(4, ScreenshotScreen.interfaceSettings),
];

const screenshotLocales = {
  'en': ['en-US'],
  'ru': ['ru'],
};

List<MapEntry<String, List<String>>> selectScreenshotLocales(String selection) {
  final languages = _parseSelection(
    selection,
    supported: screenshotLocales.keys.toSet(),
    option: 'SCREENSHOT_LOCALES',
  );
  return languages
      .map((language) => MapEntry(language, screenshotLocales[language]!))
      .toList(growable: false);
}

List<ScreenshotScenario> selectScreenshotScenarios(String selection) {
  final byId = {
    for (final scenario in screenshotScenarios) '${scenario.id}': scenario,
  };
  final ids = _parseSelection(
    selection,
    supported: byId.keys.toSet(),
    option: 'SCREENSHOT_SCENARIOS',
  );
  return ids.map((id) => byId[id]!).toList(growable: false);
}

Set<String> selectedScreenshotNames({
  required String locales,
  required String scenarios,
}) => {
  for (final locale in selectScreenshotLocales(locales))
    for (final outputLocale in locale.value)
      for (final scenario in selectScreenshotScenarios(scenarios))
        '$outputLocale/${scenario.id}',
};

Set<String> get configuredScreenshotNames =>
    selectedScreenshotNames(locales: '', scenarios: '');

List<String> _parseSelection(
  String selection, {
  required Set<String> supported,
  required String option,
}) {
  if (selection.isEmpty) return supported.toList(growable: false);

  final values = selection.split(',').map((value) => value.trim()).toList();
  if (values.any((value) => value.isEmpty)) {
    throw ArgumentError.value(selection, option, 'Empty value');
  }
  if (values.toSet().length != values.length) {
    throw ArgumentError.value(selection, option, 'Duplicate value');
  }
  final unknown = values.where((value) => !supported.contains(value)).toList();
  if (unknown.isNotEmpty) {
    throw ArgumentError.value(
      selection,
      option,
      'Unknown value: ${unknown.join(', ')}; supported: ${supported.join(', ')}',
    );
  }
  return values;
}
