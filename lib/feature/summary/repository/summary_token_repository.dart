import 'package:injectable/injectable.dart';

import '../../../component/storage/cache_storage.dart';

const yaTokenCacheKey = 'yaGptToken';

@Singleton()
class SummaryTokenRepository {
  SummaryTokenRepository(CacheStorage storage) : _storage = storage;

  final CacheStorage _storage;

  String _token = '';
  String get token => _token;

  Future<String?> getToken() async {
    if (_token.isNotEmpty) return _token;

    final cachedToken = await _storage.read(yaTokenCacheKey);
    if (cachedToken == null) {
      return null;
    }

    _token = cachedToken;
    return _token;
  }

  Future<void> setToken(String token) async {
    await _storage.write(yaTokenCacheKey, token);

    _token = token;
  }

  Future<void> clear() async {
    _token = '';

    await _storage.delete(yaTokenCacheKey);
  }
}
