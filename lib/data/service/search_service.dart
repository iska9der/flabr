import 'package:injectable/injectable.dart';

import '../../core/component/http/http.dart';
import '../exception/exception.dart';
import '../model/company/company.dart' show CompanyListResponse;
import '../model/hub/hub.dart' show HubListResponse;
import '../model/list_response_model.dart';
import '../model/publication/publication.dart';
import '../model/search/search.dart';
import '../model/user/user_list_response.dart' show UserListResponse;

abstract interface class SearchService {
  Future<ListResponse<dynamic>> fetch({
    required String query,
    required SearchTarget target,
    required String order,
    required int page,
  });
}

@LazySingleton(as: SearchService)
class SearchServiceImpl implements SearchService {
  const SearchServiceImpl(@Named('mobileClient') HttpClient client)
    : _mobileClient = client;

  final HttpClient _mobileClient;

  @override
  Future<ListResponse<dynamic>> fetch({
    required String query,
    required SearchTarget target,
    required String order,
    required int page,
  }) async {
    try {
      final params = SearchParamsFactory.from(
        query: query,
        target: target,
        order: order,
        page: page,
      );

      final queryString = params.toQueryString();
      final response = await _mobileClient.get(queryString);

      return switch (target) {
        SearchTarget.posts => PublicationCommonListResponse.fromMap(
          response.data,
        ),
        SearchTarget.hubs => HubListResponse.fromMap(response.data),
        SearchTarget.companies => CompanyListResponse.fromMap(response.data),
        SearchTarget.users => UserListResponse.fromMap(response.data),
        SearchTarget.comments => throw const ValueException(
          null,
          .searchNotImplemented,
        ),
      };
    } on AppException {
      rethrow;
    } catch (_, stackTrace) {
      Error.throwWithStackTrace(const FetchException(), stackTrace);
    }
  }
}
