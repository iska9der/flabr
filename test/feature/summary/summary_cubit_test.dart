import 'package:flabr/bloc/error/app_failure.dart';
import 'package:flabr/data/repository/summary_repository.dart';
import 'package:flabr/feature/summary/summary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ya_summary/ya_summary.dart';

void main() {
  test('maps typed API failures to app failures', () async {
    const expectedTypes = {
      SummaryExceptionType.tokenMissing:
          AppFailureType.summaryAuthorizationRequired,
      SummaryExceptionType.unauthorized:
          AppFailureType.summaryAuthorizationRequired,
      SummaryExceptionType.sharingUrlFetchFailed:
          AppFailureType.summarySharingUrlFetchFailed,
      SummaryExceptionType.summaryFetchFailed:
          AppFailureType.summaryFetchFailed,
    };

    for (final MapEntry(key: packageType, value: appType)
        in expectedTypes.entries) {
      final cubit = SummaryCubit(
        url: 'https://habr.com/articles/1',
        repository: _ThrowingRepository(SummaryException(packageType)),
      );

      await cubit.fetchSummary();

      expect(cubit.state.status, SummaryStatus.failure);
      expect(
        cubit.state.error,
        isA<AppFailure>()
            .having((failure) => failure.type, 'type', appType)
            .having(
              (failure) => failure.cause,
              'cause',
              isA<SummaryException>(),
            ),
      );
      await cubit.close();
    }
  });

  test('maps unexpected failures to the summary fallback', () async {
    final cubit = SummaryCubit(
      url: 'https://habr.com/articles/1',
      repository: _ThrowingRepository(StateError('broken response')),
    );

    await cubit.fetchSummary();

    expect(
      cubit.state.error,
      isA<AppFailure>().having(
        (failure) => failure.type,
        'type',
        AppFailureType.summaryOperationFailed,
      ),
    );
    await cubit.close();
  });
}

final class _ThrowingRepository implements SummaryRepository {
  const _ThrowingRepository(this.error);

  final Object error;

  @override
  Future<SummaryModel> fetchSummary(String url) => Future.error(error);
}
