import 'package:flabr/data/repository/summary_repository.dart';
import 'package:flabr/data/repository/summary_token_repository.dart';
import 'package:flabr/feature/summary/summary.dart';
import 'package:flabr/i18n/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ya_summary/ya_summary.dart';

void main() {
  setUp(() => LocaleSettings.setLocaleSync(AppLocale.ru));

  testWidgets('requests a token before fetching and then shows the summary', (
    tester,
  ) async {
    final tokenRepository = _MemoryTokenRepository();
    final authCubit = SummaryAuthCubit(tokenRepository: tokenRepository);
    final summaryRepository = _RecordingSummaryRepository();
    await authCubit.init();
    addTearDown(authCubit.close);

    await tester.pumpWidget(
      TranslationProvider(
        child: BlocProvider.value(
          value: authCubit,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () => showSummaryDialog(
                    context,
                    url: 'https://habr.com/articles/1',
                    repository: summaryRepository,
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('YandexGPT'), findsOneWidget);
    expect(find.text('Токен'), findsOneWidget);
    expect(summaryRepository.callCount, 0);

    await tester.enterText(find.byType(TextFormField), 'secret');
    await tester.tap(find.text('Сохранить'));
    await tester.pumpAndSettle();

    expect(summaryRepository.callCount, 1);
    expect(find.text('Summary'), findsOneWidget);
    expect(find.text('• Point'), findsOneWidget);
  });
}

final class _MemoryTokenRepository implements SummaryTokenRepository {
  String? token;

  @override
  Future<String?> getToken() async => token;

  @override
  Future<void> setToken(String token) async {
    this.token = token;
  }

  @override
  Future<void> clear() async {
    token = null;
  }
}

final class _RecordingSummaryRepository implements SummaryRepository {
  int callCount = 0;

  @override
  Future<SummaryModel> fetchSummary(String url) async {
    callCount++;
    return const SummaryModel(title: 'Summary', content: ['Point']);
  }
}
