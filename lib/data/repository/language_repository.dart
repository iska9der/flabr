import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../core/component/storage/storage.dart';
import '../../core/constants/constants.dart';
import '../exception/exception.dart';
import '../model/language/language.dart';

@Singleton()
class LanguageRepository {
  LanguageRepository({@Named('sharedStorage') required CacheStorage storage})
    : _storage = storage {
    _init();
  }

  final CacheStorage _storage;

  final _uiCtrl = StreamController<Language>.broadcast();
  Stream<Language> get ui => _uiCtrl.stream;

  final _publicationsCtrl = StreamController<List<Language>>.broadcast();
  Stream<List<Language>> get publications => _publicationsCtrl.stream;

  /// Последние значения из стрима
  Language _ui = Language.ru;
  Language get lastUI => _ui;
  List<Language> _publications = [Language.ru];
  List<Language> get lastPublications => _publications;

  /// Получаем кэшированные значения из хранилища
  /// и сохраняем как последния значения, а так же
  /// пушим значения в стрим
  Future<void> _init() async {
    final lang = await _getCachedUILanguage();
    _ui = lang ?? _ui;
    _uiCtrl.add(_ui);

    final publication = await _getCachedPublicationLanguages();
    _publications = publication ?? _publications;
    _publicationsCtrl.add(_publications);
  }

  Future<Language?> _getCachedUILanguage() async {
    try {
      String? raw = await _storage.read(CacheKeys.langUI);
      if (raw == null) {
        return null;
      }

      final lang = Language.fromString(raw);
      return lang;
    } on ValueException {
      await _storage.delete(CacheKeys.langUI);
      return null;
    }
  }

  void changeUILanguage(Language lang) {
    _ui = lang;
    _uiCtrl.add(lang);
    _storage.write(CacheKeys.langUI, lang.name);
  }

  Future<List<Language>?> _getCachedPublicationLanguages() async {
    try {
      String? raw = await _storage.read(CacheKeys.langPublications);
      if (raw == null) return null;

      final langs = LanguageEncoder.decodeLangs(raw);
      return langs;
    } on ValueException {
      await _storage.delete(CacheKeys.langPublications);
      return null;
    }
  }

  void changePublicationsLanguages(List<Language> langs) async {
    _publications = langs;
    _publicationsCtrl.add(langs);
    String langsAsString = LanguageEncoder.encodeLangs(langs);
    _storage.write(CacheKeys.langPublications, langsAsString);
  }
}
