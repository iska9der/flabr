part of 'storage.dart';

abstract interface class CacheStorage {
  Future<void> write(String key, String value);

  Future<String?> read(String key);

  Future<void> delete(String key);

  Future<void> deleteAll();
}
