part of 'repository_part.dart';

abstract interface class SummaryTokenRepository {
  static const String cacheKey = 'yaGptToken';

  Future<String?> getToken();

  Future<void> setToken(String token);

  Future<void> clear();
}

@Singleton(as: SummaryTokenRepository)
class SummaryTokenRepositoryImpl implements SummaryTokenRepository {
  SummaryTokenRepositoryImpl(this._storage);

  final CacheStorage _storage;

  String _token = '';
  String get token => _token;

  @override
  Future<String?> getToken() async {
    if (_token.isNotEmpty) return _token;

    final cachedToken = await _storage.read(SummaryTokenRepository.cacheKey);
    if (cachedToken == null) {
      return null;
    }

    _token = cachedToken;
    return _token;
  }

  @override
  Future<void> setToken(String token) async {
    await _storage.write(SummaryTokenRepository.cacheKey, token);

    _token = token;
  }

  @override
  Future<void> clear() async {
    _token = '';

    await _storage.delete(SummaryTokenRepository.cacheKey);
  }
}
