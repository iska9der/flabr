part of 'repository_part.dart';

@LazySingleton()
class CompanyRepository {
  CompanyRepository(CompanyService service) : _service = service;

  final CompanyService _service;

  Future<CompanyListResponse> fetchAll({
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

  Future<CompanyCardModel> fetchCard(
    String alias, {
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  }) async {
    final raw = await _service.fetchCard(
      alias,
      langUI: langUI.name,
      langArticles: encodeLangs(langArticles),
    );

    final model = CompanyCardModel.fromMap(raw);

    return model;
  }
}
