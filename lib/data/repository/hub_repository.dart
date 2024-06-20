part of 'part.dart';

@LazySingleton()
class HubRepository {
  HubRepository(HubService service) : _service = service;

  final HubService _service;

  Future<HubListResponse> fetchAll({
    required int page,
    required Language langUI,
    required List<Language> langArticles,
  }) async {
    final response = await _service.fetchAll(
      page: page,
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
    );

    return response;
  }

  Future<HubProfile> fetchProfile(
    String alias, {
    required Language langUI,
    required List<Language> langArticles,
  }) async {
    final raw = await _service.fetchProfile(
      alias,
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
    );

    return HubProfile.fromMap(raw);
  }
}
