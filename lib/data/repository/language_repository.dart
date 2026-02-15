import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

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

  final _uiCtrl = BehaviorSubject<Language>();
  Stream<Language> get onUIChange => _uiCtrl.asBroadcastStream();

  final _pubUICtrl = BehaviorSubject<List<Language>>();
  Stream<List<Language>> get onPubUIChange => _pubUICtrl.asBroadcastStream();

  /// Последние значения из стрима
  Language get lastUI => _uiCtrl.valueOrNull ?? Language.ru;
  List<Language> get lastPublications =>
      _pubUICtrl.valueOrNull ?? [Language.ru];

  /// Получаем кэшированные значения из хранилища
  /// и сохраняем как последния значения, а так же
  /// пушим значения в стрим
  Future<void> _init() async {
    final lang = await _getCachedUILanguage();
    if (lang != null) {
      _uiCtrl.add(lang);
    }

    final pubLang = await _getCachedPublicationLanguages();
    if (pubLang != null) {
      _pubUICtrl.add(pubLang);
    }
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
    _pubUICtrl.add(langs);
    String langsAsString = LanguageEncoder.encodeLangs(langs);
    _storage.write(CacheKeys.langPublications, langsAsString);
  }
}
