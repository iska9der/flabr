import 'package:flabr/i18n/i18n.dart';
import 'package:flabr/presentation/widget/pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() => LocaleSettings.setLocaleSync(AppLocale.ru));

  testWidgets('shows compact page ranges at the beginning', (tester) async {
    await _pumpPagination(tester, currentPage: 1);

    _expectPages([1, 2, 3, 49, 50]);
    expect(find.text('…'), findsOneWidget);
    expect(find.text('4'), findsNothing);
  });

  testWidgets('shows surrounding page ranges in the middle', (tester) async {
    await _pumpPagination(tester, currentPage: 7);

    _expectPages([1, 2, 5, 6, 7, 8, 9, 49, 50]);
    expect(find.text('…'), findsNWidgets(2));
    expect(find.text('3'), findsNothing);
    expect(find.text('10'), findsNothing);
  });

  testWidgets('shows compact page ranges at the end', (tester) async {
    await _pumpPagination(tester, currentPage: 50);

    _expectPages([1, 2, 48, 49, 50]);
    expect(find.text('…'), findsOneWidget);
    expect(find.text('47'), findsNothing);
  });

  testWidgets('selects pages and keeps previous and next buttons', (
    tester,
  ) async {
    int? selectedPage;
    await _pumpPagination(
      tester,
      currentPage: 7,
      onPageSelected: (page) => selectedPage = page,
    );

    await tester.tap(find.text('8'));
    expect(selectedPage, 8);

    await tester.tap(find.byTooltip(t.pagination.previousPage));
    expect(selectedPage, 6);

    await tester.tap(find.byTooltip(t.pagination.nextPage));
    expect(selectedPage, 8);
  });
}

Future<void> _pumpPagination(
  WidgetTester tester, {
  required int currentPage,
  ValueChanged<int>? onPageSelected,
}) async {
  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp(
        home: Scaffold(
          body: Pagination(
            currentPage: currentPage,
            pagesCount: 50,
            onPageSelected: onPageSelected ?? (_) {},
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void _expectPages(List<int> pages) {
  for (final page in pages) {
    expect(find.text('$page'), findsOneWidget);
  }
}
