import 'package:injectable/injectable.dart';

import '../model/company/company.dart';
import '../model/language/language.dart';
import '../service/service.dart';

@LazySingleton()
class CompanyRepository {
  CompanyRepository(CompanyService service) : _service = service;

  final CompanyService _service;

  Future<CompanyListResponse> fetchAll({
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

  Future<CompanyCard> fetchCard(
    String alias, {
    required Language langUI,
    required List<Language> langArticles,
  }) async {
    final raw = await _service.fetchCard(
      alias,
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
    );

    final model = CompanyCard.fromMap(raw);

    return model;
  }
}
