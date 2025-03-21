part of 'repository.dart';

@Singleton()
class TokenRepository {
  TokenRepository(@Named('secureStorage') this._storage);

  final CacheStorage _storage;

  Tokens _tokens = Tokens.empty;
  Tokens get tokens => _tokens;

  String _csrf = '';

  Future<Tokens?> getTokens() async {
    if (!_tokens.isEmpty) return _tokens;

    final raw = await _storage.read(CacheKeys.authTokens);

    if (raw == null) {
      return null;
    }

    _tokens = Tokens.fromJson(raw);

    return _tokens;
  }

  Future<void> setTokens(Tokens newTokens) async {
    await _storage.write(CacheKeys.authTokens, newTokens.toJson());

    _tokens = newTokens;
  }

  Future<String?> getCsrf() async {
    if (_csrf.isNotEmpty) return _csrf;

    final raw = await _storage.read(CacheKeys.authCsrf);

    if (raw == null) {
      return null;
    }

    _csrf = raw;

    return raw;
  }

  Future<void> setCsrf(String value) async {
    await _storage.write(CacheKeys.authCsrf, value);

    _csrf = value;
  }

  Future<void> clearAll() async {
    _tokens = Tokens.empty;
    _csrf = '';

    await _storage.delete(CacheKeys.authTokens);
    await _storage.delete(CacheKeys.authCsrf);
  }
}
