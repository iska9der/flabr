part of 'part.dart';

@Singleton()
class TokenRepository {
  TokenRepository(@Named('secureStorage') this._storage);

  final CacheStorage _storage;

  Tokens _tokens = Tokens.empty;
  Tokens get tokens => _tokens;

  String _csrf = '';

  Future<Tokens?> getTokens() async {
    if (!_tokens.isEmpty) return _tokens;

    final raw = await _storage.read(CacheKey.authTokens);

    if (raw == null) {
      return null;
    }

    _tokens = Tokens.fromJson(raw);

    return _tokens;
  }

  Future<void> setTokens(Tokens data) async {
    await _storage.write(CacheKey.authTokens, data.toJson());

    _tokens = data;
  }

  Future<String?> getCsrf() async {
    if (_csrf.isNotEmpty) return _csrf;

    final raw = await _storage.read(CacheKey.authCsrf);

    if (raw == null) {
      return null;
    }

    _csrf = raw;

    return raw;
  }

  Future<void> setCsrf(String value) async {
    await _storage.write(CacheKey.authCsrf, value);

    _csrf = value;
  }

  Future<void> clearAll() async {
    _tokens = Tokens.empty;
    _csrf = '';

    await _storage.delete(CacheKey.authTokens);
    await _storage.delete(CacheKey.authCsrf);
  }
}
