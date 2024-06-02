part of 'repository_part.dart';

const langUICacheKey = 'langUI';
const langArticlesCacheKey = 'langArticles';

@Singleton()
class LanguageRepository {
  LanguageRepository({
    required CacheStorage storage,
  }) : _storage = storage {
    _init();
  }

  final CacheStorage _storage;

  final _uiController = StreamController<LanguageEnum>.broadcast();
  Stream<LanguageEnum> get uiStream => _uiController.stream;

  final _articlesController = StreamController<List<LanguageEnum>>.broadcast();
  Stream<List<LanguageEnum>> get articlesStream => _articlesController.stream;

  /// Последние значения из стрима
  LanguageEnum _ui = LanguageEnum.ru;
  get ui => _ui;

  List<LanguageEnum> _articles = [LanguageEnum.ru];
  get articles => _articles;

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

  Future<LanguageEnum?> _getCachedUILanguage() async {
    try {
      String? raw = await _storage.read(langUICacheKey);
      if (raw == null) return null;

      final lang = LanguageEnum.fromString(raw);
      return lang;
    } on ValueException {
      await _storage.delete(langUICacheKey);
      return null;
    }
  }

  void updateUILang(LanguageEnum lang) {
    _ui = lang;
    _uiController.add(lang);
    _storage.write(langUICacheKey, lang.name);
  }

  Future<List<LanguageEnum>?> _getCachedArticlesLanguage() async {
    try {
      String? raw = await _storage.read(langArticlesCacheKey);
      if (raw == null) return null;

      final langs = decodeLangs(raw);
      return langs;
    } on ValueException {
      await _storage.delete(langArticlesCacheKey);
      return null;
    }
  }

  void updateArticleLang(List<LanguageEnum> langs) async {
    _articles = langs;
    _articlesController.add(langs);
    String langsAsString = encodeLangs(langs);
    _storage.write(langArticlesCacheKey, langsAsString);
  }
}
