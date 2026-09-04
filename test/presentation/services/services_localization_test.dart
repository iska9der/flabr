import 'package:flabr/i18n/i18n.dart';
import 'package:flabr/presentation/page/services/services_page.dart';
import 'package:flabr/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('service labels update without restarting the app', (
    tester,
  ) async {
    LocaleSettings.setLocaleSync(AppLocale.ru);
    final russianLabels = [
      t.services.hubs,
      t.services.authors,
      t.services.companies,
    ];

    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const ServicesPageView(),
        ),
      ),
    );

    for (final label in russianLabels) {
      expect(find.text(label), findsOneWidget);
    }

    LocaleSettings.setLocaleSync(AppLocale.en);
    await tester.pumpAndSettle();

    final englishLabels = [
      t.services.hubs,
      t.services.authors,
      t.services.companies,
    ];
    expect(englishLabels, isNot(equals(russianLabels)));
    for (final label in russianLabels) {
      expect(find.text(label), findsNothing);
    }
    for (final label in englishLabels) {
      expect(find.text(label), findsOneWidget);
    }
  });
}
