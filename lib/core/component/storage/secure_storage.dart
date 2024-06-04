part of 'part.dart';

class SecureStorage implements CacheStorage {
  SecureStorage(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<void> write(String key, String value) => _storage.write(
        key: key,
        value: value,
      );

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}
