import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/constants/constants.dart';

@Singleton()
class TokenRepository {
  TokenRepository({required this.cookieJar});

  final CookieJar cookieJar;

  final _tokenController = BehaviorSubject<String>.seeded('');
  Stream<String> get onTokenChanged => _tokenController.stream;
  String get token => _tokenController.value;

  String? _csrf;
  String? get csrf => _csrf;

  Future<void> init() async {
    final uri = Uri.parse(Urls.baseUrl);
    final cookies = await cookieJar.loadForRequest(uri);
    final current = _readSid(cookies.where((c) => c.name == Keys.sidToken));

    /// TODO: в 1.5.0 удалить миграцию с `connect_sid` и восстановление сессии по её значению
    final legacyCookies = cookies.where((c) => c.name == Keys.legacySidToken);
    final legacy = _readSid(legacyCookies);
    if (legacyCookies.isNotEmpty) {
      await cookieJar.saveFromResponse(uri, [
        if (current == null && legacy != null)
          Cookie.fromSetCookieValue(legacy.toString())..name = Keys.sidToken,
        for (final cookie in legacyCookies)
          Cookie(cookie.name, '')
            ..domain = cookie.domain
            ..path = cookie.path
            ..maxAge = 0,
      ]);
    }

    _emitToken(current?.value ?? legacy?.value ?? '');
  }

  Future<void> saveToken(String newToken) async {
    if (newToken.isNotEmpty) {
      await _persistToken(newToken);
    }

    _emitToken(newToken);
  }

  Cookie? _readSid(Iterable<Cookie> cookies) {
    Cookie? fallback;
    for (final cookie in cookies) {
      if (cookie.value.isEmpty) {
        continue;
      }

      fallback ??= cookie;
      if (cookie.path == null || cookie.path == '/') {
        return cookie;
      }
    }

    return fallback;
  }

  Future<void> _persistToken(String token) async {
    final cookie = Cookie(Keys.sidToken, token)..path = '/';
    await cookieJar.saveFromResponse(Uri.parse(Urls.baseUrl), [cookie]);
  }

  void _emitToken(String token) {
    if (token == _tokenController.value) {
      return;
    }

    _tokenController.add(token);
  }

  void setCsrf(String value) {
    if (_csrf == value || value.isEmpty) {
      return;
    }

    _csrf = value;
  }

  Future<void> clearAll() async {
    _csrf = null;
    await cookieJar.deleteAll();
    _tokenController.add('');
  }
}
