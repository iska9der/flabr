import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/component/storage/storage.dart';
import '../../core/constants/constants.dart';
import '../../presentation/page/settings/model/config_model.dart';

@prod
@dev
@Singleton()
class SettingsRepository {
  SettingsRepository({
    @Named('sharedStorage') required this._storage,
  });

  final CacheStorage _storage;

  final _configCtrl = BehaviorSubject<Config>.seeded(const Config());

  /// Поток актуальной конфигурации с replay последнего значения
  Stream<Config> get onChange => _configCtrl.stream;

  /// Последняя опубликованная конфигурация
  Config get lastConfig => _configCtrl.value;

  /// Инициализация конфигурации
  Future<Config> initConfig() async {
    Config config = const .new();

    String? raw = await _storage.read(CacheKeys.themeConfig);
    if (raw != null) {
      ThemeConfigModel cachedTheme = .fromJson(jsonDecode(raw));

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
      config = config.copyWith(feed: .fromJson(jsonDecode(raw)));
    }

    raw = await _storage.read(CacheKeys.publicationConfig);
    if (raw != null) {
      config = config.copyWith(publication: .fromJson(jsonDecode(raw)));
    }

    raw = await _storage.read(CacheKeys.miscConfig);
    if (raw != null) {
      config = config.copyWith(misc: .fromJson(jsonDecode(raw)));
    }

    raw = await _storage.read(CacheKeys.typographyConfig);
    if (raw != null) {
      config = config.copyWith(typography: .fromJson(jsonDecode(raw)));
    }

    _configCtrl.add(config);

    return config;
  }

  void saveTheme(ThemeConfigModel config) {
    _storage.write(CacheKeys.themeConfig, jsonEncode(config.toJson()));
    _configCtrl.add(lastConfig.copyWith(theme: config));
  }

  void saveFeed(FeedConfigModel config) {
    _storage.write(CacheKeys.feedConfig, jsonEncode(config.toJson()));
    _configCtrl.add(lastConfig.copyWith(feed: config));
  }

  void savePublication(PublicationConfigModel config) {
    _storage.write(CacheKeys.publicationConfig, jsonEncode(config.toJson()));
    _configCtrl.add(lastConfig.copyWith(publication: config));
  }

  void saveMisc(MiscConfigModel config) {
    _storage.write(CacheKeys.miscConfig, jsonEncode(config.toJson()));
    _configCtrl.add(lastConfig.copyWith(misc: config));
  }

  void saveTypography(TypographyConfigModel config) {
    _storage.write(CacheKeys.typographyConfig, jsonEncode(config.toJson()));
    _configCtrl.add(lastConfig.copyWith(typography: config));
  }
}
