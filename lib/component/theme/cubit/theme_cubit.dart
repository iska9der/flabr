import 'package:bloc/bloc.dart';
import '../../storage/cache_storage.dart';

const isDarkCacheKey = 'isDarkTheme';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit(CacheStorage storage)
      : _storage = storage,
        super(false);

  final CacheStorage _storage;

  void init() async {
    String? raw = await _storage.read(isDarkCacheKey);

    if (raw != null) {
      bool parsed = raw == 'true';

      toggle(value: parsed);
    } else {
      await _storage.write(isDarkCacheKey, 'false');
      toggle(value: false);
    }
  }

  void toggle({required bool value}) async {
    await _storage.write(isDarkCacheKey, value.toString());
    emit(value);
  }
}
