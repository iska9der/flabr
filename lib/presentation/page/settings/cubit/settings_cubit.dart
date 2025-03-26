import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/storage/storage.dart';
import '../../../../core/constants/constants.dart';
import '../../../../data/model/language/language.dart';
import '../../../../data/repository/repository.dart';
import '../model/config_model.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required LanguageRepository languageRepository,
    required CacheStorage storage,
  }) : _storage = storage,
       _langRepository = languageRepository,
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

    final (langUI, langArticles) = _initLanguages();
    final config = await _initConfig();

    emit(
      state.copyWith(
        status: SettingsStatus.success,
        langUI: langUI,
        langArticles: langArticles,
        theme: config.theme,
        feed: config.feed,
        publication: config.publication,
        misc: config.misc,
      ),
    );
  }

  (Language, List<Language>) _initLanguages() => (
    _langRepository.ui,
    _langRepository.articles,
  );

  changeUILang(Language? uiLang) {
    if (uiLang == null) return;

    emit(state.copyWith(langUI: uiLang));

    _langRepository.updateUILang(uiLang);
  }

  (bool, List<Language>) validateChangeArticlesLang(
    Language lang, {
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

  changeArticleLang(Language lang, {bool? isEnabled}) async {
    if (isEnabled == null) return;
    var (isValid, newLangs) = validateChangeArticlesLang(
      lang,
      isEnabled: isEnabled,
    );
    if (!isValid) return;

    emit(state.copyWith(langArticles: newLangs));

    _langRepository.updateArticleLang(newLangs);
  }

  /// Инициализация конфигурации
  Future<Config> _initConfig() async {
    Config config = const Config();

    String? raw = await _storage.read(CacheKeys.themeConfig);
    if (raw != null) {
      var cachedTheme = ThemeConfigModel.fromJson(jsonDecode(raw));

      /// Костыль для плавного перехода на новую структуру конфигурации.
      /// Удалить блок вместе с isDarkTheme
      if (cachedTheme.modeByBool != null) {
        cachedTheme = cachedTheme.copyWith(
          mode: cachedTheme.modeByBool!,
          isDarkTheme: null,
        );
        _storage.write(CacheKeys.themeConfig, jsonEncode(cachedTheme.toJson()));
      }

      config = config.copyWith(theme: cachedTheme);
    }

    raw = await _storage.read(CacheKeys.feedConfig);
    if (raw != null) {
      config = config.copyWith(feed: FeedConfigModel.fromJson(jsonDecode(raw)));
    }

    raw = await _storage.read(CacheKeys.publicationConfig);
    if (raw != null) {
      config = config.copyWith(
        publication: PublicationConfigModel.fromJson(jsonDecode(raw)),
      );
    }

    raw = await _storage.read(CacheKeys.miscConfig);
    if (raw != null) {
      config = config.copyWith(misc: MiscConfigModel.fromJson(jsonDecode(raw)));
    }

    return config;
  }

  void changeTheme(ThemeMode mode) {
    if (state.theme.mode == mode) return;

    final newConfig = state.theme.copyWith(mode: mode, isDarkTheme: null);

    emit(state.copyWith(theme: newConfig));

    _storage.write(CacheKeys.themeConfig, jsonEncode(newConfig.toJson()));
  }

  void changeFeedImageVisibility({bool? isVisible}) {
    if (isVisible == null || state.feed.isImageVisible == isVisible) {
      return;
    }

    final newConfig = state.feed.copyWith(isImageVisible: isVisible);

    emit(state.copyWith(feed: newConfig));

    _storage.write(CacheKeys.feedConfig, jsonEncode(newConfig.toJson()));
  }

  void changeFeedDescVisibility({bool? isVisible}) {
    if (isVisible == null || state.feed.isDescriptionVisible == isVisible) {
      return;
    }

    final newConfig = state.feed.copyWith(isDescriptionVisible: isVisible);

    emit(state.copyWith(feed: newConfig));

    _storage.write(CacheKeys.feedConfig, jsonEncode(newConfig.toJson()));
  }

  void changeArticleFontScale(double newScale) {
    if (state.publication.fontScale == newScale) return;

    var newConfig = state.publication.copyWith(fontScale: newScale);

    emit(state.copyWith(publication: newConfig));

    _storage.write(CacheKeys.publicationConfig, jsonEncode(newConfig.toJson()));
  }

  void changeArticleImageVisibility({bool? isVisible}) {
    if (isVisible == null || state.publication.isImagesVisible == isVisible) {
      return;
    }

    var newConfig = state.publication.copyWith(isImagesVisible: isVisible);

    emit(state.copyWith(publication: newConfig));

    _storage.write(CacheKeys.publicationConfig, jsonEncode(newConfig.toJson()));
  }

  void changeWebViewVisibility({bool? isVisible}) {
    if (isVisible == null || state.publication.webViewEnabled == isVisible) {
      return;
    }

    var newConfig = state.publication.copyWith(webViewEnabled: isVisible);

    emit(state.copyWith(publication: newConfig));

    _storage.write(CacheKeys.publicationConfig, jsonEncode(newConfig.toJson()));
  }

  void changeNavigationOnScrollVisibility({bool? isVisible}) {
    if (isVisible == null ||
        state.misc.navigationOnScrollVisible == isVisible) {
      return;
    }

    var newConfig = state.misc.copyWith(navigationOnScrollVisible: isVisible);
    emit(state.copyWith(misc: newConfig));

    _storage.write(CacheKeys.miscConfig, jsonEncode(newConfig.toJson()));
  }

  void changeScrollVariant(ScrollVariant variant) {
    if (state.misc.scrollVariant == variant) {
      return;
    }

    var newConfig = state.misc.copyWith(scrollVariant: variant);
    emit(state.copyWith(misc: newConfig));

    _storage.write(CacheKeys.miscConfig, jsonEncode(newConfig.toJson()));
  }
}
