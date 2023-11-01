import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/language.dart';
import '../../../component/router/app_router.dart';
import '../../../component/storage/cache_storage.dart';
import '../model/article_config_model.dart';
import '../model/feed_config_model.dart';
import '../model/misc_config_model.dart';
import '../repository/language_repository.dart';

part 'settings_state.dart';

const isDarkThemeCacheKey = 'isDarkTheme';
const feedConfigCacheKey = 'feedConfig';
const articleConfigCacheKey = 'articleConfig';
const miscConfigCacheKey = 'miscConfig';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required CacheStorage storage,
    required LanguageRepository languageRepository,
    required AppRouter router,
    required AppLinks appLinks,
  })  : _storage = storage,
        _langRepository = languageRepository,
        _router = router,
        _appLinks = appLinks,
        super(const SettingsState()) {
    _langUiSub = _langRepository.uiStream.listen((lang) {
      emit(state.copyWith(langUI: lang));
    });
    _langArticleSub = _langRepository.articlesStream.listen((langs) {
      emit(state.copyWith(langArticles: langs));
    });
  }

  final LanguageRepository _langRepository;
  final CacheStorage _storage;
  final AppLinks _appLinks;
  final AppRouter _router;

  late final StreamSubscription _langUiSub;
  late final StreamSubscription _langArticleSub;

  @override
  Future<void> close() {
    _langUiSub.cancel();
    _langArticleSub.cancel();
    return super.close();
  }

  void init() async {
    emit(state.copyWith(status: SettingsStatus.loading));

    /// todo: эту штуку можно оптимизировать, на мой блестящий взгляд:
    /// возвращать из функций значения и менять state одним поджопником
    await initTheme();
    await initConfig();
    await initDeepLink();

    emit(state.copyWith(status: SettingsStatus.success));
  }

  changeUILang(LanguageEnum? uiLang) {
    if (uiLang == null) return;

    emit(state.copyWith(langUI: uiLang));

    _langRepository.updateUILang(uiLang);
  }

  (bool, List<LanguageEnum>) validateChangeArticlesLang(
    LanguageEnum lang, {
    required bool isEnabled,
  }) {
    var newLangs = [...state.langArticles];

    if (isEnabled) {
      newLangs.add(lang);
    } else {
      newLangs.remove(lang);
    }

    if (newLangs.isEmpty) return (false, []);

    return (true, newLangs);
  }

  changeArticleLang(LanguageEnum lang, {bool? isEnabled}) async {
    if (isEnabled == null) return;
    var (isValid, newLangs) = validateChangeArticlesLang(
      lang,
      isEnabled: isEnabled,
    );
    if (!isValid) return;

    emit(state.copyWith(langArticles: newLangs));

    _langRepository.updateArticleLang(newLangs);
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

  /// Инициализация конфигурации
  initConfig() async {
    String? raw = await _storage.read(feedConfigCacheKey);
    FeedConfigModel? feedConfig;
    if (raw != null) {
      feedConfig = FeedConfigModel.fromJson(raw);
    }

    raw = await _storage.read(articleConfigCacheKey);
    ArticleConfigModel? articleConfig;
    if (raw != null) {
      articleConfig = ArticleConfigModel.fromJson(raw);
    }

    raw = await _storage.read(miscConfigCacheKey);
    MiscConfigModel? miscConfig;
    if (raw != null) {
      miscConfig = MiscConfigModel.fromJson(raw);
    }

    emit(state.copyWith(
      feedConfig: feedConfig,
      articleConfig: articleConfig,
      miscConfig: miscConfig,
    ));
  }

  void changeFeedImageVisibility({bool? isVisible}) {
    if (state.feedConfig.isImageVisible == isVisible) return;

    final newConfig = state.feedConfig.copyWith(isImageVisible: isVisible);

    emit(state.copyWith(feedConfig: newConfig));

    _storage.write(feedConfigCacheKey, newConfig.toJson());
  }

  void changeFeedDescVisibility({bool? isVisible}) {
    if (state.feedConfig.isDescriptionVisible == isVisible) return;

    final newConfig = state.feedConfig.copyWith(
      isDescriptionVisible: isVisible,
    );

    emit(state.copyWith(feedConfig: newConfig));

    _storage.write(feedConfigCacheKey, newConfig.toJson());
  }

  void changeArticleFontScale(double newScale) {
    if (state.articleConfig.fontScale == newScale) return;

    var newConfig = state.articleConfig.copyWith(fontScale: newScale);
    emit(state.copyWith(articleConfig: newConfig));

    _storage.write(articleConfigCacheKey, newConfig.toJson());
  }

  void changeArticleImageVisibility({bool? isVisible}) {
    if (state.articleConfig.isImagesVisible == isVisible) return;

    var newConfig = state.articleConfig.copyWith(isImagesVisible: isVisible);
    emit(state.copyWith(articleConfig: newConfig));

    _storage.write(articleConfigCacheKey, newConfig.toJson());
  }

  void changeWebViewVisibility({bool? isVisible}) {
    if (state.articleConfig.webViewEnabled == isVisible) return;

    var newConfig = state.articleConfig.copyWith(webViewEnabled: isVisible);
    emit(state.copyWith(articleConfig: newConfig));

    _storage.write(articleConfigCacheKey, newConfig.toJson());
  }

  void changeNavigationOnScrollVisibility({bool? isVisible}) {
    if (state.miscConfig.navigationOnScrollVisible == isVisible) return;

    var newConfig = state.miscConfig.copyWith(
      navigationOnScrollVisible: isVisible,
    );
    emit(state.copyWith(miscConfig: newConfig));

    _storage.write(miscConfigCacheKey, newConfig.toJson());
  }
}
