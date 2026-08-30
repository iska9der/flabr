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

    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const ServicesPageView(),
        ),
      ),
    );

    expect(find.text('Хабы'), findsOneWidget);
    expect(find.text('Авторы'), findsOneWidget);
    expect(find.text('Компании'), findsOneWidget);

    LocaleSettings.setLocaleSync(AppLocale.en);
    await tester.pumpAndSettle();

    expect(find.text('Hubs'), findsOneWidget);
    expect(find.text('Authors'), findsOneWidget);
    expect(find.text('Companies'), findsOneWidget);
  });
}
