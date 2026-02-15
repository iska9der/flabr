import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/model/language/language.dart';
import '../../data/repository/repository.dart';
import '../../presentation/page/settings/model/config_model.dart';

part 'settings_state.dart';

@Singleton()
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required SettingsRepository repository,
    required LanguageRepository languageRepository,
  }) : _repository = repository,
       _langRepository = languageRepository,
       super(const SettingsState()) {
    _uiLangSub = _langRepository.onUIChange.listen((lang) {
      emit(state.copyWith(langUI: lang));
    });

    _publicationsLangsSub = _langRepository.onPubUIChange.listen((langs) {
      emit(state.copyWith(langArticles: langs));
    });
  }

  final SettingsRepository _repository;
  final LanguageRepository _langRepository;

  late final StreamSubscription<Language> _uiLangSub;
  late final StreamSubscription<List<Language>> _publicationsLangsSub;

  @override
  Future<void> close() {
    _uiLangSub.cancel();
    _publicationsLangsSub.cancel();
    return super.close();
  }

  Future<void> init() async {
    if (state.status == .loading) {
      return;
    }

    emit(state.copyWith(status: .loading));

    try {
      final (uiLang, publicationsLangs) = _initLanguages();
      final config = await _repository.initConfig();

      emit(
        state.copyWith(
          status: .success,
          langUI: uiLang,
          langArticles: publicationsLangs,
          theme: config.theme,
          feed: config.feed,
          publication: config.publication,
          misc: config.misc,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: SettingsStatus.failure));

      super.onError(error, stackTrace);
    }
  }

  (Language, List<Language>) _initLanguages() => (
    _langRepository.lastUI,
    _langRepository.lastPublications,
  );

  void changeUILang(Language? uiLang) {
    if (uiLang == null || uiLang == state.langUI) {
      return;
    }

    _langRepository.changeUILanguage(uiLang);
  }

  (bool, List<Language>) validateLang(
    Language lang, {
    required bool isEnabled,
  }) {
    final newLangs = [...state.langArticles];

    switch (isEnabled) {
      case true:
        newLangs.add(lang);
      case false:
        newLangs.remove(lang);
    }

    return (newLangs.isNotEmpty, newLangs);
  }

  Future<void> changeArticleLang(Language lang, {bool? isEnabled}) async {
    if (isEnabled == null) {
      return;
    }

    final (isValid, newLangs) = validateLang(lang, isEnabled: isEnabled);
    if (!isValid) {
      return;
    }
    _langRepository.changePublicationsLanguages(newLangs);
  }

  void changeTheme(ThemeMode mode) {
    if (state.theme.mode == mode) {
      return;
    }

    final newConfig = state.theme.copyWith(mode: mode, isDarkTheme: null);
    _repository.saveTheme(newConfig);
    emit(state.copyWith(theme: newConfig));
  }

  void changeFeedImageVisibility({bool? isVisible}) {
    if (isVisible == null || state.feed.isImageVisible == isVisible) {
      return;
    }

    final newConfig = state.feed.copyWith(isImageVisible: isVisible);
    _repository.saveFeed(newConfig);
    emit(state.copyWith(feed: newConfig));
  }

  void changeFeedDescVisibility({bool? isVisible}) {
    if (isVisible == null || state.feed.isDescriptionVisible == isVisible) {
      return;
    }

    final newConfig = state.feed.copyWith(isDescriptionVisible: isVisible);
    _repository.saveFeed(newConfig);
    emit(state.copyWith(feed: newConfig));
  }

  void changeArticleFontScale(double newScale) {
    if (state.publication.fontScale == newScale) {
      return;
    }

    final newConfig = state.publication.copyWith(fontScale: newScale);
    _repository.savePublication(newConfig);
    emit(state.copyWith(publication: newConfig));
  }

  void changeArticleImageVisibility({bool? isVisible}) {
    if (isVisible == null || state.publication.isImagesVisible == isVisible) {
      return;
    }

    final newConfig = state.publication.copyWith(isImagesVisible: isVisible);
    _repository.savePublication(newConfig);
    emit(state.copyWith(publication: newConfig));
  }

  void changeWebViewVisibility({bool? isVisible}) {
    if (isVisible == null || state.publication.webViewEnabled == isVisible) {
      return;
    }

    final newConfig = state.publication.copyWith(webViewEnabled: isVisible);
    _repository.savePublication(newConfig);
    emit(state.copyWith(publication: newConfig));
  }

  void changeNavigationOnScrollVisibility({bool? isVisible}) {
    if (isVisible == null ||
        state.misc.navigationOnScrollVisible == isVisible) {
      return;
    }

    final newConfig = state.misc.copyWith(navigationOnScrollVisible: isVisible);
    _repository.saveMisc(newConfig);
    emit(state.copyWith(misc: newConfig));
  }

  void changeScrollVariant(ScrollVariant variant) {
    if (state.misc.scrollVariant == variant) {
      return;
    }

    final newConfig = state.misc.copyWith(scrollVariant: variant);
    _repository.saveMisc(newConfig);
    emit(state.copyWith(misc: newConfig));
  }
}
