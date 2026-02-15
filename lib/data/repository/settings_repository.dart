import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../core/component/storage/storage.dart';
import '../../core/constants/constants.dart';
import '../../presentation/page/settings/model/config_model.dart';

@prod
@dev
@Singleton()
class SettingsRepository {
  SettingsRepository({
    @Named('sharedStorage') required CacheStorage storage,
  }) : _storage = storage;

  final CacheStorage _storage;

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

    return config;
  }

  void saveTheme(ThemeConfigModel config) {
    _storage.write(CacheKeys.themeConfig, jsonEncode(config.toJson()));
  }

  void saveFeed(FeedConfigModel config) {
    _storage.write(CacheKeys.feedConfig, jsonEncode(config.toJson()));
  }

  void savePublication(PublicationConfigModel config) {
    _storage.write(CacheKeys.publicationConfig, jsonEncode(config.toJson()));
  }

  void saveMisc(MiscConfigModel config) {
    _storage.write(CacheKeys.miscConfig, jsonEncode(config.toJson()));
  }
}
