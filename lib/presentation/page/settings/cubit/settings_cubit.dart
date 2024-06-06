import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/router/app_router.dart';
import '../../../../core/component/storage/part.dart';
import '../../../../core/constants/part.dart';
import '../../../../data/model/language/part.dart';
import '../../../../data/repository/part.dart';
import '../model/config_model.dart';

part 'settings_state.dart';

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

    _uriSub = _appLinks.uriLinkStream.listen((uri) {
      String path = uri.path;

      _router.navigateNamed(path);
    });
  }

  final LanguageRepository _langRepository;
  final CacheStorage _storage;
  final AppLinks _appLinks;
  final AppRouter _router;

  late final StreamSubscription _langUiSub;
  late final StreamSubscription _langArticleSub;
  late final StreamSubscription _uriSub;

  @override
  Future<void> close() {
    _langUiSub.cancel();
    _langArticleSub.cancel();
    _uriSub.cancel();
    return super.close();
  }

  void init() async {
    emit(state.copyWith(status: SettingsStatus.loading));

    final lastUrl = await _initDeepLink();
    final (langUI, langArticles) = _initLanguages();
    final isDark = await _initIsDarkTheme();
    final config = await _initConfig();

    emit(state.copyWith(
      status: SettingsStatus.success,
      initialDeepLink: lastUrl,
      langUI: langUI,
      langArticles: langArticles,
      isDarkTheme: isDark,
      feedConfig: config.feed,
      publicationConfig: config.publication,
      miscConfig: config.misc,
    ));
  }

  (LanguageEnum, List<LanguageEnum>) _initLanguages() =>
      (_langRepository.ui, _langRepository.articles);

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

  Future<bool> _initIsDarkTheme() async {
    /// Получаем кэшированные данные
    String? raw = await _storage.read(CacheKey.isDarkTheme);

    /// Если в кэше есть заданное значение, присваиваем его,
    /// иначе указываем как false
    if (raw != null) {
      bool isDarkTheme = raw == 'true';
      return isDarkTheme;
    }

    _storage.write(CacheKey.isDarkTheme, 'false');
    return false;
  }

  void changeTheme({required bool isDarkTheme}) {
    _storage.write(CacheKey.isDarkTheme, isDarkTheme.toString());

    emit(state.copyWith(isDarkTheme: isDarkTheme));
  }

  Future<String?> _initDeepLink() async {
    final lastUri = await _appLinks.getLatestLink();

    return lastUri?.path;
  }

  /// Инициализация конфигурации
  Future<Config> _initConfig() async {
    String? raw = await _storage.read(CacheKey.feedConfig);
    FeedConfigModel? feedConfig;
    if (raw != null) {
      feedConfig = FeedConfigModel.fromJson(raw);
    }

    raw = await _storage.read(CacheKey.articleConfig);
    PublicationConfigModel? articleConfig;
    if (raw != null) {
      articleConfig = PublicationConfigModel.fromJson(raw);
    }

    raw = await _storage.read(CacheKey.miscConfig);
    MiscConfigModel? miscConfig;
    if (raw != null) {
      miscConfig = MiscConfigModel.fromJson(raw);
    }

    return const Config().copyWith(
      feed: feedConfig,
      publication: articleConfig,
      misc: miscConfig,
    );
  }

  void changeFeedImageVisibility({bool? isVisible}) {
    if (state.feedConfig.isImageVisible == isVisible) return;

    final newConfig = state.feedConfig.copyWith(isImageVisible: isVisible);

    emit(state.copyWith(feedConfig: newConfig));

    _storage.write(CacheKey.feedConfig, newConfig.toJson());
  }

  void changeFeedDescVisibility({bool? isVisible}) {
    if (state.feedConfig.isDescriptionVisible == isVisible) return;

    final newConfig = state.feedConfig.copyWith(
      isDescriptionVisible: isVisible,
    );

    emit(state.copyWith(feedConfig: newConfig));

    _storage.write(CacheKey.feedConfig, newConfig.toJson());
  }

  void changeArticleFontScale(double newScale) {
    if (state.publicationConfig.fontScale == newScale) return;

    var newConfig = state.publicationConfig.copyWith(fontScale: newScale);
    emit(state.copyWith(publicationConfig: newConfig));

    _storage.write(CacheKey.articleConfig, newConfig.toJson());
  }

  void changeArticleImageVisibility({bool? isVisible}) {
    if (state.publicationConfig.isImagesVisible == isVisible) return;

    var newConfig =
        state.publicationConfig.copyWith(isImagesVisible: isVisible);
    emit(state.copyWith(publicationConfig: newConfig));

    _storage.write(CacheKey.articleConfig, newConfig.toJson());
  }

  void changeWebViewVisibility({bool? isVisible}) {
    if (state.publicationConfig.webViewEnabled == isVisible) return;

    var newConfig = state.publicationConfig.copyWith(webViewEnabled: isVisible);
    emit(state.copyWith(publicationConfig: newConfig));

    _storage.write(CacheKey.articleConfig, newConfig.toJson());
  }

  void changeNavigationOnScrollVisibility({bool? isVisible}) {
    if (state.miscConfig.navigationOnScrollVisible == isVisible) return;

    var newConfig = state.miscConfig.copyWith(
      navigationOnScrollVisible: isVisible,
    );
    emit(state.copyWith(miscConfig: newConfig));

    _storage.write(CacheKey.miscConfig, newConfig.toJson());
  }
}
