import 'package:app_links/app_links.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/value_exception.dart';
import '../../../component/language.dart';
import '../../../component/router/app_router.dart';
import '../../../component/storage/cache_storage.dart';
import '../model/article_config_model.dart';
import '../model/feed_config_model.dart';

part 'settings_state.dart';

const isDarkThemeCacheKey = 'isDarkTheme';
const langUICacheKey = 'langUI';
const langArticlesCacheKey = 'langArticles';
const feedConfigCacheKey = 'feedConfig';
const articleConfigCacheKey = 'articleConfig';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required CacheStorage storage,
    required this.router,
    required AppLinks appLinks,
  })  : _storage = storage,
        _appLinks = appLinks,
        super(const SettingsState());

  final CacheStorage _storage;
  final AppLinks _appLinks;
  final AppRouter router;

  void init() async {
    emit(state.copyWith(status: SettingsStatus.loading));

    /// todo: эту штуку можно оптимизировать, на мой блестящий взгляд:
    /// возвращать из функций значения и менять state одним поджопником
    await initLocales();
    await initTheme();
    await initFeedConfig();
    await initArticleConfig();
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

  changeUILang(LanguageEnum? uiLang) {
    if (uiLang == null) return;

    _storage.write(langUICacheKey, uiLang.name);

    emit(state.copyWith(langUI: uiLang));
  }

  changeArticlesLang(LanguageEnum lang, {bool? isEnabled}) {
    if (isEnabled == null) return;

    var langs = [...state.langArticles];

    if (isEnabled) {
      langs.add(lang);
    } else {
      langs.remove(lang);
    }

    if (langs.isEmpty) return;

    String langsAsString = encodeLangs(langs);
    _storage.write(langArticlesCacheKey, langsAsString);

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

      router.navigateNamed(path);
    });
  }

  /// FEED CONFIG
  ///

  initFeedConfig() async {
    String? raw = await _storage.read(feedConfigCacheKey);

    if (raw == null) return;

    FeedConfigModel config = FeedConfigModel.fromJson(raw);

    emit(state.copyWith(feedConfig: config));
  }

  void changeFeedImageVisibility({bool? isVisible}) {
    if (state.feedConfig.isImageVisible == isVisible) return;

    var newConfig = state.feedConfig.copyWith(isImageVisible: isVisible);

    _storage.write(feedConfigCacheKey, newConfig.toJson());

    emit(state.copyWith(feedConfig: newConfig));
  }

  void changeFeedDescVisibility({bool? isVisible}) {
    if (state.feedConfig.isDescriptionVisible == isVisible) return;

    var newConfig = state.feedConfig.copyWith(isDescriptionVisible: isVisible);

    _storage.write(feedConfigCacheKey, newConfig.toJson());

    emit(state.copyWith(feedConfig: newConfig));
  }

  /// ARTICLE CONFIG
  ///

  initArticleConfig() async {
    String? raw = await _storage.read(articleConfigCacheKey);

    if (raw == null) return;

    ArticleConfigModel config = ArticleConfigModel.fromJson(raw);

    emit(state.copyWith(articleConfig: config));
  }

  void changeArticleFontScale(double newScale) {
    if (state.articleConfig.fontScale == newScale) return;

    var newConfig = state.articleConfig.copyWith(fontScale: newScale);

    _storage.write(articleConfigCacheKey, newConfig.toJson());

    emit(state.copyWith(articleConfig: newConfig));
  }

  void changeArticleImageVisibility({bool? isVisible}) {
    if (state.articleConfig.isImagesVisible == isVisible) return;

    var newConfig = state.articleConfig.copyWith(isImagesVisible: isVisible);

    _storage.write(articleConfigCacheKey, newConfig.toJson());

    emit(state.copyWith(articleConfig: newConfig));
  }
}
