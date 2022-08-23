import 'package:app_links/app_links.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../component/storage/cache_storage.dart';

part 'settings_state.dart';

const isDarkThemeCacheKey = 'isDarkTheme';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required CacheStorage storage,
    required AppLinks appLinks,
  })  : _storage = storage,
        _appLinks = appLinks,
        super(const SettingsState());

  final CacheStorage _storage;
  final AppLinks _appLinks;

  void init() async {
    emit(state.copyWith(status: SettingsStatus.loading));

    await initTheme();
    await initDeepLink();

    emit(state.copyWith(status: SettingsStatus.success));
  }

  Future<void> initTheme() async {
    /// Получаем кэшированные данные
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
  }

  void changeTheme({required bool isDarkTheme}) {
    _storage.write(isDarkThemeCacheKey, isDarkTheme.toString());

    emit(state.copyWith(isDarkTheme: isDarkTheme));
  }

  Future<void> initDeepLink() async {
    final uri = await _appLinks.getInitialAppLink();

    if (uri != null) {
      emit(state.copyWith(initialDeepLink: uri.path));
    }
  }
}
