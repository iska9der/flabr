import 'package:app_links/app_links.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../component/language.dart';
import '../../../common/exception/value_exception.dart';
import '../../../component/router/app_router.dart';
import '../../../component/storage/cache_storage.dart';

part 'settings_state.dart';

const isDarkThemeCacheKey = 'isDarkTheme';
const langUICacheKey = 'langUI';
const langArticlesCacheKey = 'langArticles';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required CacheStorage storage,
    required AppRouter router,
    required AppLinks appLinks,
  })  : _storage = storage,
        _router = router,
        _appLinks = appLinks,
        super(const SettingsState());

  final CacheStorage _storage;
  final AppLinks _appLinks;
  final AppRouter _router;

  void init() async {
    emit(state.copyWith(status: SettingsStatus.loading));

    await initLocales();
    await initTheme();
    await initDeepLink();

    emit(state.copyWith(status: SettingsStatus.success));
  }

  Future<void> initLocales() async {
    await initUILang();
    await initArticlesLang();
  }

  Future<void> initUILang() async {
    String? raw = await _storage.read(langUICacheKey);

    if (raw == null) return;

    try {
      final uiLang = LanguageEnum.fromString(raw);

      emit(state.copyWith(langUI: uiLang));
    } on ValueException {
      await _storage.delete(langUICacheKey);
    }
  }

  Future<void> initArticlesLang() async {
    String? raw = await _storage.read(langArticlesCacheKey);

    if (raw == null) return;

    try {
      final langs = decodeLangs(raw);

      emit(state.copyWith(langArticles: langs));
    } on ValueException {
      await _storage.delete(langArticlesCacheKey);
    }
  }

  changeUILang(LanguageEnum? uiLang) async {
    if (uiLang == null) return;

    await _storage.write(langUICacheKey, uiLang.name);

    emit(state.copyWith(langUI: uiLang));
  }

  changeArticlesLang(LanguageEnum lang, {bool? isEnabled}) async {
    if (isEnabled == null) return;

    var langs = [...state.langArticles];

    if (isEnabled) {
      langs.add(lang);
    } else {
      langs.remove(lang);
    }

    if (langs.isEmpty) return;

    String langsAsString = encodeLangs(langs);

    await _storage.write(langArticlesCacheKey, langsAsString);

    emit(state.copyWith(langArticles: langs));
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
    final lastUri = await _appLinks.getLatestAppLink();

    if (lastUri != null) {
      emit(state.copyWith(initialDeepLink: lastUri.path));
    }

    _appLinks.uriLinkStream.listen((uri) {
      String path = uri.path;

      _router.navigateNamed(path);
    });
  }
}
