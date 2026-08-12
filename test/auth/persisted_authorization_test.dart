import 'dart:typed_data';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flabr/core/component/http/habra_client.dart';
import 'package:flabr/core/component/logger/logger.dart';
import 'package:flabr/core/component/storage/cache_storage.dart';
import 'package:flabr/core/constants/constants.dart';
import 'package:flabr/data/repository/language_repository.dart';
import 'package:flabr/data/repository/token_repository.dart';
import 'package:flabr/data/service/profile_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TokenRepository persisted authorization', () {
    test('restores a site SID to both cookie hosts', () async {
      final storage = MemoryCookieStorage();
      final initialJar = PersistCookieJar(storage: storage);
      await initialJar.saveFromResponse(Uri.parse(Urls.baseUrl), [
        Cookie(Keys.sidToken, 'site-sid')..path = '/',
      ]);

      final restartedJar = PersistCookieJar(storage: storage);
      final repository = TokenRepository(cookieJar: restartedJar);
      await repository.init();

      expect(repository.token, 'site-sid');
      await expectSid(restartedJar, Urls.baseUrl, 'site-sid');
      await expectSid(restartedJar, Urls.mobileBaseUrl, 'site-sid');
    });

    test('site SID replaces a conflicting mobile SID on restart', () async {
      final storage = MemoryCookieStorage();
      final initialJar = PersistCookieJar(storage: storage);
      await initialJar.saveFromResponse(Uri.parse(Urls.baseUrl), [
        Cookie(Keys.sidToken, 'site-sid')..path = '/',
      ]);
      await initialJar.saveFromResponse(Uri.parse(Urls.mobileBaseUrl), [
        Cookie(Keys.sidToken, 'mobile-sid')..path = '/',
      ]);

      final restartedJar = PersistCookieJar(storage: storage);
      final repository = TokenRepository(cookieJar: restartedJar);
      await repository.init();

      expect(repository.token, 'site-sid');
      await expectSid(restartedJar, Urls.baseUrl, 'site-sid');
      await expectSid(restartedJar, Urls.mobileBaseUrl, 'site-sid');
    });

    test('sends a restored SID through CSRF and site interceptors', () async {
      final storage = MemoryCookieStorage();
      final initialJar = PersistCookieJar(storage: storage);
      await initialJar.saveFromResponse(Uri.parse(Urls.baseUrl), [
        Cookie(Keys.sidToken, 'site-sid')..path = '/',
      ]);

      final restartedJar = PersistCookieJar(storage: storage);
      final repository = TokenRepository(cookieJar: restartedJar);
      await repository.init();

      final dio = Dio(BaseOptions(baseUrl: Urls.siteApiUrl));
      final client = HabraClient(
        dio,
        logger: NoOpLogger(),
        tokenRepository: repository,
        languageRepository: LanguageRepository(storage: MemoryCacheStorage()),
      );
      await client.init();
      final adapter = RecordingHttpClientAdapter();
      dio.httpClientAdapter = adapter;

      final service = ProfileServiceImpl(
        siteClient: client,
      );
      final profile = await service.fetchMe();

      expect(profile, isEmpty);
      expect(adapter.requests, hasLength(2));

      final csrfRequest = adapter.requests.first;
      expect(
        '${csrfRequest.uri.scheme}://${csrfRequest.uri.host}'
            '${csrfRequest.uri.path}',
        'https://habr.com/ru/conversations/',
      );
      expectSingleSid(csrfRequest, 'site-sid');
      expect(csrfRequest.headers, isNot(contains(Keys.skipCsrf)));

      final meRequest = adapter.requests.last;
      expect(
        '${meRequest.uri.scheme}://${meRequest.uri.host}${meRequest.uri.path}',
        'https://habr.com/kek/v2/me',
      );
      expectSingleSid(meRequest, 'site-sid');
      expect(meRequest.headers[Keys.csrfToken], 'test-csrf');
      expect(meRequest.headers, isNot(contains(Keys.skipCsrf)));
      expect(meRequest.headers, isNot(contains(Keys.renewCsrf)));
      expect(meRequest.headers['cookie'], contains('fl=ru'));
      expect(meRequest.headers['cookie'], contains('hl=ru'));
      expect(meRequest.queryParameters['fl'], 'ru');
      expect(meRequest.queryParameters['hl'], 'ru');
    });
  });
}

Future<void> expectSid(
  CookieJar cookieJar,
  String url,
  String expectedValue,
) async {
  final sidCookies = (await cookieJar.loadForRequest(
    Uri.parse(url),
  )).where((cookie) => cookie.name == Keys.sidToken).toList();

  expect(sidCookies, hasLength(1));
  expect(sidCookies.single.value, expectedValue);
  expect(sidCookies.single.path, '/');
}

void expectSingleSid(RequestOptions request, String expectedValue) {
  final cookieHeader = request.headers['cookie'] as String? ?? '';
  final sidCookies = cookieHeader
      .split(';')
      .map((cookie) => cookie.trim())
      .where((cookie) => cookie.startsWith('${Keys.sidToken}='))
      .toList();

  expect(sidCookies, ['${Keys.sidToken}=$expectedValue']);
}

final class MemoryCookieStorage extends Storage {
  final Map<String, String> _values = {};

  @override
  Future<void> init(bool persistSession, bool ignoreExpires) async {}

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }

  @override
  Future<void> deleteAll(List<String> keys) async {
    for (final key in keys) {
      _values.remove(key);
    }
  }
}

final class RecordingHttpClientAdapter implements HttpClientAdapter {
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);

    if (options.uri.host == 'habr.com' &&
        options.uri.path == '/ru/conversations/') {
      return ResponseBody.fromString(
        '<meta name="csrf-token" content="test-csrf">',
        200,
        headers: {
          Headers.contentTypeHeader: ['text/html; charset=utf-8'],
        },
      );
    }

    return ResponseBody.fromString(
      '{}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

final class MemoryCacheStorage implements CacheStorage {
  final Map<String, String> _values = {};

  @override
  Future<void> write(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _values.clear();
  }
}

final class NoOpLogger implements Logger {
  @override
  void info(Object message, {String? title}) {}

  @override
  void warning(Object message, {String? title, StackTrace? stackTrace}) {}

  @override
  void error(Object message, Object exception, StackTrace? trace) {}
}
