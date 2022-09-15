import '../../../component/language.dart';
import '../model/hub_profile_model.dart';
import '../model/network/hub_list_response.dart';
import '../repository/hub_repository.dart';

class HubService {
  HubService(HubRepository repository) : _repository = repository;

  final HubRepository _repository;

  /// пока не нужно
  // HubListResponse cached = HubListResponse.empty;

  Future<HubListResponse> fetchAll({
    required int page,
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  }) async {
    final response = await _repository.fetchAll(
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
    final raw = await _repository.fetchProfile(
      alias,
      langUI: langUI.name,
      langArticles: encodeLangs(langArticles),
    );

    return HubProfileModel.fromMap(raw);
  }

  Future<void> toggleSubscription({required String alias}) async {
    await _repository.toggleSubscription(alias: alias);
  }
}
