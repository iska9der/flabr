// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:injectable/injectable.dart';

import '../../../component/localization/language_enum.dart';
import '../../../component/localization/language_helper.dart';
import '../model/card/company_card_model.dart';
import '../model/network/company_list_response.dart';
import '../service/company_service.dart';

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
