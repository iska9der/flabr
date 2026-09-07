import 'dart:io';

import 'package:flabr/bootstrap.dart';
import 'package:flabr/core/component/logger/logger.dart';
import 'package:flabr/core/constants/constants.dart';
import 'package:flabr/presentation/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'screenshots/screenshot_config.dart';
import 'screenshots/screenshot_scenario.dart';

const _localeSelection = String.fromEnvironment('SCREENSHOT_LOCALES');
const _scenarioSelection = String.fromEnvironment('SCREENSHOT_SCENARIOS');

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Store selected screenshots',
    (tester) async {
      expect(
        AppEnvironment.isDemo,
        isTrue,
        reason: 'Requires --dart-define=ENV=demo',
      );
      expect(kDebugMode, isFalse, reason: 'Use a profile build without DEBUG');
      expect(Platform.isAndroid, isTrue);

      await Bootstrap.init(logger: ConsoleLogger());
      await tester.pumpWidget(const Application());
      await binding.convertFlutterSurfaceToImage();
      await tester.pump();

      final locales = selectScreenshotLocales(_localeSelection);
      final scenarios = selectScreenshotScenarios(_scenarioSelection);
      final capture = ScreenshotCapture(tester, binding);
      await capture.waitForApplication();
      for (final locale in locales) {
        await capture.configureLanguage(locale.key);
        for (final scenario in scenarios) {
          await capture.show(scenario.screen);
          for (final outputLocale in locale.value) {
            await capture.capture('$outputLocale/${scenario.id}');
          }
        }
      }
      expect(
        capture.names,
        selectedScreenshotNames(
          locales: _localeSelection,
          scenarios: _scenarioSelection,
        ),
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
