import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../core/component/storage/storage.dart';
import '../../core/constants/constants.dart';
import '../model/tokens_model.dart';

@Singleton()
class TokenRepository {
  TokenRepository(@Named('secureStorage') this._storage);

  final CacheStorage _storage;

  Tokens _tokens = Tokens.empty;
  Tokens get tokens => _tokens;

  String? _csrf;
  String? get csrf => _csrf;

  Future<Tokens?> getTokens() async {
    if (_tokens.isNotEmpty) {
      return _tokens;
    }

    final raw = await _storage.read(CacheKeys.authTokens);
    if (raw == null) {
      return null;
    }

    _tokens = Tokens.fromJson(raw);

    return _tokens;
  }

  Future<void> saveTokens(Tokens newTokens) async {
    if (newTokens.isEmpty) {
      return;
    }

    await _storage.write(CacheKeys.authTokens, newTokens.toJson());

    _tokens = newTokens;
  }

  void setCsrf(String value) {
    if (_csrf == value || value.isEmpty) {
      return;
    }

    _csrf = value;
  }

  Future<void> clearAll() async {
    _tokens = Tokens.empty;
    _csrf = '';

    await _storage.delete(CacheKeys.authTokens);
  }
}
