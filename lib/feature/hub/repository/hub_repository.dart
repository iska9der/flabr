import '../../../component/language.dart';
import '../model/hub_profile_model.dart';
import '../model/network/hub_list_response.dart';
import '../service/hub_service.dart';

class HubRepository {
  HubRepository(HubService service) : _service = service;

  final HubService _service;

  /// пока не нужно
  // HubListResponse cached = HubListResponse.empty;

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

    // cached = cached.copyWith(refs: [...cached.refs, ...response.refs]);

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
