part of 'part.dart';

@Singleton()
class LanguageRepository {
  LanguageRepository({
    @Named('sharedStorage') required CacheStorage storage,
  }) : _storage = storage {
    _init();
  }

  final CacheStorage _storage;

  final _uiController = StreamController<Language>.broadcast();
  Stream<Language> get uiStream => _uiController.stream;

  final _articlesController = StreamController<List<Language>>.broadcast();
  Stream<List<Language>> get articlesStream => _articlesController.stream;

  /// Последние значения из стрима
  Language _ui = Language.ru;
  Language get ui => _ui;

  List<Language> _articles = [Language.ru];
  List<Language> get articles => _articles;

  /// Получаем кэшированные значения из хранилища
  /// и сохраняем как последния значения, а так же
  /// пушим значения в стрим
  Future<void> _init() async {
    final lang = await _getCachedUILanguage();
    _ui = lang ?? _ui;
    _uiController.add(_ui);

    final article = await _getCachedArticlesLanguage();
    _articles = article ?? _articles;
    _articlesController.add(_articles);
  }

  Future<Language?> _getCachedUILanguage() async {
    try {
      String? raw = await _storage.read(CacheKeys.langUI);
      if (raw == null) return null;

      final lang = Language.fromString(raw);
      return lang;
    } on ValueException {
      await _storage.delete(CacheKeys.langUI);
      return null;
    }
  }

  void updateUILang(Language lang) {
    _ui = lang;
    _uiController.add(lang);
    _storage.write(CacheKeys.langUI, lang.name);
  }

  Future<List<Language>?> _getCachedArticlesLanguage() async {
    try {
      String? raw = await _storage.read(CacheKeys.langArticle);
      if (raw == null) return null;

      final langs = LanguageEncoder.decodeLangs(raw);
      return langs;
    } on ValueException {
      await _storage.delete(CacheKeys.langArticle);
      return null;
    }
  }

  void updateArticleLang(List<Language> langs) async {
    _articles = langs;
    _articlesController.add(langs);
    String langsAsString = LanguageEncoder.encodeLangs(langs);
    _storage.write(CacheKeys.langArticle, langsAsString);
  }
}
