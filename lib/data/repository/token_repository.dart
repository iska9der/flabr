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
    final siteCookies = await cookieJar.loadForRequest(
      Uri.parse(Urls.baseUrl),
    );
    final mobileCookies = await cookieJar.loadForRequest(
      Uri.parse(Urls.mobileBaseUrl),
    );
    final siteToken = _readToken(siteCookies);
    final mobileToken = _readToken(mobileCookies);
    final token = siteToken ?? mobileToken ?? '';

    if (token.isNotEmpty && (siteToken != token || mobileToken != token)) {
      await _persistToken(token);
    }

    _emitToken(token);
  }

  Future<void> saveToken(String newToken) async {
    if (newToken.isNotEmpty) {
      await _persistToken(newToken);
    }

    _emitToken(newToken);
  }

  String? _readToken(List<Cookie> cookies) {
    String? fallback;
    for (final cookie in cookies) {
      if (cookie.name != Keys.sidToken) {
        continue;
      }

      fallback ??= cookie.value;
      if (cookie.path == null || cookie.path == '/') {
        return cookie.value;
      }
    }

    return fallback;
  }

  Future<void> _persistToken(String token) async {
    final siteCookie = Cookie(Keys.sidToken, token)..path = '/';
    await cookieJar.saveFromResponse(Uri.parse(Urls.baseUrl), [siteCookie]);

    final mobileCookie = Cookie(Keys.sidToken, token)..path = '/';
    await cookieJar.saveFromResponse(Uri.parse(Urls.mobileBaseUrl), [
      mobileCookie,
    ]);
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
