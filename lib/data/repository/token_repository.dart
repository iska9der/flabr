part of 'part.dart';

const authDataCacheKey = 'aData';
const authCsrfCacheKey = 'cData';

@Singleton()
class TokenRepository {
  TokenRepository(@Named('secureStorage') this._storage);

  final CacheStorage _storage;

  AuthDataModel _authData = AuthDataModel.empty;
  AuthDataModel get authData => _authData;

  String _csrf = '';

  Future<AuthDataModel?> getData() async {
    if (!_authData.isEmpty) return _authData;

    final raw = await _storage.read(authDataCacheKey);

    if (raw == null) {
      return null;
    }

    _authData = AuthDataModel.fromJson(raw);

    return _authData;
  }

  Future<void> setData(AuthDataModel data) async {
    await _storage.write(authDataCacheKey, data.toJson());

    _authData = data;
  }

  Future<String?> getCsrf() async {
    if (_csrf.isNotEmpty) return _csrf;

    final raw = await _storage.read(authCsrfCacheKey);

    if (raw == null) {
      return null;
    }

    _csrf = raw;

    return raw;
  }

  Future<void> setCsrf(String value) async {
    await _storage.write(authCsrfCacheKey, value);

    _csrf = value;
  }

  Future<void> clearAll() async {
    _authData = AuthDataModel.empty;
    _csrf = '';

    await _storage.delete(authDataCacheKey);
    await _storage.delete(authCsrfCacheKey);
  }
}
