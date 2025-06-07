import 'dart:async';

import 'package:collection/collection.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/constants/constants.dart';

@Singleton()
class TokenRepository {
  TokenRepository({required this.cookieJar});

  final CookieJar cookieJar;

  final _tokenController = BehaviorSubject<String>.seeded('');
  Stream<String> get onTokenChanged => _tokenController.asBroadcastStream();
  String get token => _tokenController.value;

  String? _csrf;
  String? get csrf => _csrf;

  Future<void> init() async {
    /// Получаем из кук токен [Keys.sidToken]
    final cookies = await cookieJar.loadForRequest(Uri.parse(Urls.baseUrl));
    final token =
        cookies
            .firstWhereOrNull((cookie) => cookie.name == Keys.sidToken)
            ?.value ??
        '';

    saveToken(token);
  }

  Future<void> saveToken(String newToken, {bool asCookie = false}) async {
    if (newToken == _tokenController.value) {
      return;
    }

    if (asCookie) {
      final Cookie cookie = Cookie(Keys.sidToken, newToken);
      await cookieJar.saveFromResponse(Uri.parse(Urls.baseUrl), [cookie]);
      await cookieJar.saveFromResponse(Uri.parse(Urls.mobileBaseUrl), [cookie]);
    }

    _tokenController.add(newToken);
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
