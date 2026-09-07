import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';
import 'package:path/path.dart' as path;

import '../integration_test/screenshots/screenshot_config.dart';

Future<void> main() async {
  final output = Platform.environment['SCREENSHOT_DIR'];
  if (output == null || output.isEmpty) {
    throw StateError(
      'Run sh scripts/update_screenshots.sh <android-device-id> to stage screenshots',
    );
  }

  final localeSelection = Platform.environment['SCREENSHOT_LOCALES'] ?? '';
  final scenarioSelection = Platform.environment['SCREENSHOT_SCENARIOS'] ?? '';
  final expected = selectedScreenshotNames(
    locales: localeSelection,
    scenarios: scenarioSelection,
  );
  final captured = <String>{};
  await integrationDriver(
    onScreenshot: (name, bytes, [args]) async {
      if (!expected.contains(name) || !captured.add(name)) {
        throw StateError('Unexpected or duplicate screenshot: $name');
      }
      final file = File(path.join(output, '$name.png'));
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes, flush: true);
      stdout.writeln('Captured $name.png');
      return true;
    },
    responseDataCallback: (_) {
      final missing = expected.difference(captured);
      if (missing.isNotEmpty) {
        throw StateError('Missing screenshots: ${missing.join(', ')}');
      }
    },
  );
}
