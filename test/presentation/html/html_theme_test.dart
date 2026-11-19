import 'package:flabr/presentation/theme/theme.dart';
import 'package:flabr/presentation/widget/html_view/html_view_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('HTML links follow the current application theme', (
    tester,
  ) async {
    for (final theme in [AppTheme.light(), AppTheme.dark()]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: HtmlView(
              textHtml: '<p><a href="https://habr.com">Themed link</a></p>',
              renderMode: .column,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(_textColor(tester, 'Themed link'), theme.colorScheme.primary);
    }
  });

  testWidgets('HTML link colors explicitly set by the author are preserved', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: const Scaffold(
          body: HtmlView(
            textHtml:
                '<p><a href="https://habr.com" style="color: #c1292e">'
                'Custom link</a></p>',
            renderMode: .column,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(_textColor(tester, 'Custom link'), const Color(0xffc1292e));
  });
}

Color? _textColor(WidgetTester tester, String text) {
  final richText = tester.widget<RichText>(
    find.text(text, findRichText: true),
  );
  return richText.text
      .getSpanForPosition(const TextPosition(offset: 0))
      ?.style
      ?.color;
}
