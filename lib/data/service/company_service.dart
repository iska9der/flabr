import 'package:injectable/injectable.dart';

import '../../core/component/http/http.dart';
import '../model/company/company.dart';

abstract interface class CompanyService {
  Future<CompanyListResponse> fetchAll({required int page});

  Future<CompanyCard> fetchCard(String alias);

  Future<void> toggleSubscription({required String alias});
}

@LazySingleton(as: CompanyService)
class CompanyServiceImpl implements CompanyService {
  const CompanyServiceImpl({
    @Named('mobileClient') required HttpClient mobileClient,
    @Named('siteClient') required HttpClient siteClient,
  }) : _mobileClient = mobileClient,
       _siteClient = siteClient;

  final HttpClient _mobileClient;
  final HttpClient _siteClient;

  @override
  Future<CompanyListResponse> fetchAll({required int page}) async {
    final params = CompanyListParams(page: page.toString()).toMap();
    final response = await _mobileClient.get(
      '/companies/',
      queryParams: params,
    );

    return CompanyListResponse.fromMap(response.data);
  }

  @override
  Future<CompanyCard> fetchCard(String alias) async {
    final response = await _mobileClient.get('/companies/$alias/card');

    return CompanyCard.fromMap(response.data);
  }

  @override
  Future<void> toggleSubscription({required String alias}) async {
    await _siteClient.post('/v2/companies/$alias/subscription', body: {});
  }
}
