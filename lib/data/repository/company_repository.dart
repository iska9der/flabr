import 'package:injectable/injectable.dart';

import '../model/company/company.dart';
import '../service/service.dart';

@LazySingleton()
class CompanyRepository {
  CompanyRepository(CompanyService service) : _service = service;

  final CompanyService _service;

  Future<CompanyListResponse> fetchAll({required int page}) async {
    final response = await _service.fetchAll(page: page);

    return response;
  }

  Future<CompanyCard> fetchCard(String alias) async {
    final raw = await _service.fetchCard(alias);

    final model = CompanyCard.fromMap(raw);

    return model;
  }
}
