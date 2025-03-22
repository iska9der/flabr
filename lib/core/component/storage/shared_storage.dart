import 'package:shared_preferences/shared_preferences.dart';

import 'cache_storage.dart';

class SharedStorage implements CacheStorage {
  SharedStorage(this._storage);

  final SharedPreferences _storage;

  @override
  Future<void> write(String key, String value) =>
      _storage.setString(key, value);

  @override
  Future<String?> read(String key) async =>
      Future.value(_storage.getString(key));

  @override
  Future<void> delete(String key) => _storage.remove(key);

  @override
  Future<void> deleteAll() => _storage.clear();
}
