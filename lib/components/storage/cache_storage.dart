import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheStorage {
  CacheStorage(FlutterSecureStorage storage) : _storage = storage;

  final FlutterSecureStorage _storage;

  /// see [FlutterSecureStorage.write]
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// see [FlutterSecureStorage.read]
  Future<String?> read(String key) async {
    String? value = await _storage.read(key: key);
    return value;
  }

  /// see [FlutterSecureStorage.delete]
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// see [FlutterSecureStorage.deleteAll]
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
