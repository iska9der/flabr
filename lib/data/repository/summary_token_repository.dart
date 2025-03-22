import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:ya_summary/ya_summary.dart';

import '../../core/component/storage/storage.dart';

@Singleton(as: SummaryTokenRepository)
class SummaryTokenRepositoryImpl implements SummaryTokenRepository {
  SummaryTokenRepositoryImpl(@Named('secureStorage') this._storage);

  final CacheStorage _storage;

  final String _cacheKey = 'yaGptToken';
  String _token = '';

  @override
  Future<String?> getToken() async {
    if (_token.isNotEmpty) return _token;

    final cachedToken = await _storage.read(_cacheKey);
    if (cachedToken == null) {
      return null;
    }

    _token = cachedToken;
    return _token;
  }

  @override
  Future<void> setToken(String token) async {
    await _storage.write(_cacheKey, token);

    _token = token;
  }

  @override
  Future<void> clear() async {
    _token = '';

    await _storage.delete(_cacheKey);
  }
}
