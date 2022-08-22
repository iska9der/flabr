import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../component/storage/cache_storage.dart';

part 'settings_state.dart';

const isDarkThemeCacheKey = 'isDarkTheme';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(CacheStorage storage)
      : _storage = storage,
        super(const SettingsState());

  final CacheStorage _storage;

  void init() async {
    emit(state.copyWith(status: SettingsStatus.loading));

    /// Получаем кэшированные данные
    /// Theme
    String? raw = await _storage.read(isDarkThemeCacheKey);

    /// Если в кэше есть заданное значение, присваиваем его,
    /// иначе указываем как false
    if (raw != null) {
      bool isDarkTheme = raw == 'true';
      changeTheme(isDarkTheme: isDarkTheme);
    } else {
      _storage.write(isDarkThemeCacheKey, 'false');
      changeTheme(isDarkTheme: false);
    }

    emit(state.copyWith(status: SettingsStatus.success));
  }

  void changeTheme({required bool isDarkTheme}) {
    _storage.write(isDarkThemeCacheKey, isDarkTheme.toString());

    emit(state.copyWith(isDarkTheme: isDarkTheme));
  }
}
