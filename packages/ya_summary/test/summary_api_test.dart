import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:ya_summary/ya_summary.dart';

void main() {
  test('requires a token before making a request', () async {
    final adapter = _QueueAdapter([]);
    final api = SummaryApi(
      dio: Dio()..httpClientAdapter = adapter,
      tokenProvider: () async => null,
    );

    await expectLater(
      api.fetchSummary('https://habr.com/articles/1'),
      throwsA(
        isA<SummaryException>().having(
          (error) => error.type,
          'type',
          SummaryExceptionType.tokenMissing,
        ),
      ),
    );
    expect(adapter.requests, isEmpty);
  });

  test('fetches and parses a summary with the current token', () async {
    final adapter = _QueueAdapter([
      const _Reply(200, {'sharing_url': 'https://300.ya.ru/v_abcd'}),
      const _Reply(200, {
        'status_code': 2,
        'title': 'Title',
        'sharing_url': 'https://300.ya.ru/v_abcd',
        'thesis': [
          {'content': 'First'},
          {'content': 'Second'},
        ],
      }),
    ]);
    final api = SummaryApi(
      dio: Dio()..httpClientAdapter = adapter,
      tokenProvider: () async => 'secret',
    );

    final summary = await api.fetchSummary('https://habr.com/articles/1');

    expect(summary.title, 'Title');
    expect(summary.content, ['First', 'Second']);
    expect(adapter.requests, hasLength(2));
    expect(
      adapter.requests.every(
        (request) => request.headers['Authorization'] == 'OAuth secret',
      ),
      isTrue,
    );
    expect(adapter.requests.first.path, '/sharing-url');
    expect(adapter.requests.last.data, {'token': 'v_abcd'});
  });

  test('maps authorization responses to unauthorized', () async {
    final api = SummaryApi(
      dio: Dio()..httpClientAdapter = _QueueAdapter([const _Reply(401, {})]),
      tokenProvider: () async => 'expired',
    );

    await expectLater(
      api.fetchSummary('https://habr.com/articles/1'),
      throwsA(
        isA<SummaryException>().having(
          (error) => error.type,
          'type',
          SummaryExceptionType.unauthorized,
        ),
      ),
    );
  });

  test('maps each request stage to its exception type', () async {
    final sharingApi = SummaryApi(
      dio: Dio()..httpClientAdapter = _QueueAdapter([const _Reply(500, {})]),
      tokenProvider: () async => 'token',
    );
    final summaryApi = SummaryApi(
      dio: Dio()
        ..httpClientAdapter = _QueueAdapter([
          const _Reply(200, {'sharing_url': 'https://300.ya.ru/v_abcd'}),
          const _Reply(200, {'status_code': 1}),
        ]),
      tokenProvider: () async => 'token',
    );

    await expectLater(
      sharingApi.fetchSummary('https://habr.com/articles/1'),
      throwsA(
        isA<SummaryException>().having(
          (error) => error.type,
          'type',
          SummaryExceptionType.sharingUrlFetchFailed,
        ),
      ),
    );
    await expectLater(
      summaryApi.fetchSummary('https://habr.com/articles/1'),
      throwsA(
        isA<SummaryException>().having(
          (error) => error.type,
          'type',
          SummaryExceptionType.summaryFetchFailed,
        ),
      ),
    );
  });

  test('does not mask parsing errors as SummaryException', () async {
    final api = SummaryApi(
      dio: Dio()
        ..httpClientAdapter = _QueueAdapter([
          const _Reply(200, {'sharing_url': 'https://300.ya.ru/v_abcd'}),
          const _Reply(200, {
            'status_code': 2,
            'thesis': [
              {'content': 1},
            ],
          }),
        ]),
      tokenProvider: () async => 'token',
    );

    await expectLater(
      api.fetchSummary('https://habr.com/articles/1'),
      throwsA(isA<TypeError>()),
    );
  });
}

final class _Reply {
  const _Reply(this.statusCode, this.data);

  final int statusCode;
  final Map<String, dynamic> data;
}

final class _QueueAdapter implements HttpClientAdapter {
  _QueueAdapter(Iterable<_Reply> replies) : _replies = Queue.of(replies);

  final Queue<_Reply> _replies;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final reply = _replies.removeFirst();

    return ResponseBody.fromString(
      jsonEncode(reply.data),
      reply.statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
