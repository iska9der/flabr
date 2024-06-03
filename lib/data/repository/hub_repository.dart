part of 'part.dart';

@LazySingleton()
class HubRepository {
  HubRepository(HubService service) : _service = service;

  final HubService _service;

  Future<HubListResponse> fetchAll({
    required int page,
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  }) async {
    final response = await _service.fetchAll(
      page: page,
      langUI: langUI.name,
      langArticles: encodeLangs(langArticles),
    );

    return response;
  }

  Future<HubProfileModel> fetchProfile(
    String alias, {
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  }) async {
    final raw = await _service.fetchProfile(
      alias,
      langUI: langUI.name,
      langArticles: encodeLangs(langArticles),
    );

    return HubProfileModel.fromMap(raw);
  }
}
