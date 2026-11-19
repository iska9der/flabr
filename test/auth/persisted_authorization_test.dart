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
    test('restores a persisted site SID', () async {
      final storage = MemoryCookieStorage();
      final initialJar = PersistCookieJar(storage: storage);
      await initialJar.saveFromResponse(Uri.parse(Urls.baseUrl), [
        Cookie('habr_web_sid', 'site-sid')..path = '/',
      ]);

      final restartedJar = PersistCookieJar(storage: storage);
      final repository = TokenRepository(cookieJar: restartedJar);
      await repository.init();

      expect(repository.token, 'site-sid');
      await expectSid(restartedJar, Urls.baseUrl, 'site-sid');
    });

    test('prefers the current SID when both cookies are stored', () async {
      final storage = MemoryCookieStorage();
      final uri = Uri.parse(Urls.baseUrl);
      await PersistCookieJar(storage: storage).saveFromResponse(uri, [
        Cookie('connect_sid', 'old-sid')..path = '/',
        Cookie('habr_web_sid', 'current-sid')
          ..domain = uri.host
          ..path = '/',
        Cookie('preference', 'keep'),
      ]);

      final repository = TokenRepository(
        cookieJar: PersistCookieJar(storage: storage),
      );
      await repository.init();
      expect(repository.token, 'current-sid');

      final cookies = await PersistCookieJar(
        storage: storage,
      ).loadForRequest(uri);
      expect(
        {for (final cookie in cookies) cookie.name: cookie.value},
        {
          'habr_web_sid': 'current-sid',
          'preference': 'keep',
        },
      );
    });

    test('migrates a legacy SID before the first profile request', () async {
      final storage = MemoryCookieStorage();
      final initialJar = PersistCookieJar(storage: storage);
      await initialJar.saveFromResponse(Uri.parse(Urls.baseUrl), [
        Cookie('connect_sid', 'site-sid')..path = '/',
      ]);

      final restartedJar = PersistCookieJar(storage: storage);
      final repository = TokenRepository(cookieJar: restartedJar);
      await repository.init();
      repository.setCsrf('stale-csrf');

      final adapter = RecordingHttpClientAdapter();
      final service = await createProfileService(repository, adapter);
      final profile = await service.fetchMe();

      expect(profile?.id, isEmpty);
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

      final nextLaunch = TokenRepository(
        cookieJar: PersistCookieJar(storage: storage),
      );
      await nextLaunch.init();
      expect(nextLaunch.token, 'site-sid');
      await nextLaunch.clearAll();
      final afterLogout = TokenRepository(
        cookieJar: PersistCookieJar(storage: storage),
      );
      await afterLogout.init();
      expect(afterLogout.token, isEmpty);
    });

    test('sends the profile request without stale CSRF when refresh returns no token', () async {
      final repository = TokenRepository(cookieJar: CookieJar());
      await repository.saveToken('site-sid');
      repository.setCsrf('stale-csrf');
      final adapter = RecordingHttpClientAdapter(csrfHtml: '<html></html>');
      final service = await createProfileService(repository, adapter);

      await service.fetchMe();

      expect(adapter.requests.map((request) => request.uri.path), [
        '/ru/conversations/',
        '/kek/v2/me',
      ]);
      expect(adapter.requests.last.headers, isNot(contains(Keys.csrfToken)));
    });
  });
}

Future<ProfileService> createProfileService(
  TokenRepository repository,
  RecordingHttpClientAdapter adapter,
) async {
  final dio = Dio(BaseOptions(baseUrl: Urls.siteApiUrl));
  final client = HabraClient(
    dio,
    logger: NoOpLogger(),
    tokenRepository: repository,
    languageRepository: LanguageRepository(storage: MemoryCacheStorage()),
  );
  await client.init();
  dio.httpClientAdapter = adapter;
  return ProfileServiceImpl(siteClient: client);
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
      .where(
        (cookie) =>
            cookie.startsWith('habr_web_sid=') ||
            cookie.startsWith('connect_sid='),
      )
      .toList();

  expect(sidCookies, ['habr_web_sid=$expectedValue']);
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
  RecordingHttpClientAdapter({
    this.csrfHtml = '<meta name="csrf-token" content="test-csrf">',
  });

  final String csrfHtml;
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
        csrfHtml,
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
