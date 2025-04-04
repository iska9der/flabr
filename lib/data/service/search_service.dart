import 'package:injectable/injectable.dart';

import '../../core/component/http/http.dart';
import '../exception/exception.dart';
import '../model/search/search.dart';

abstract interface class SearchService {
  Future fetch({
    required String langUI,
    required String langArticles,
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
  Future fetch({
    required String langUI,
    required String langArticles,
    required String query,
    required SearchTarget target,
    required String order,
    required int page,
  }) async {
    try {
      final params = SearchParamsFactory.from(
        langUI: langUI,
        langArticles: langArticles,
        query: query,
        target: target,
        order: order,
        page: page,
      );

      final queryString = params.toQueryString();
      final response = await _mobileClient.get(queryString);

      return response.data;
    } on AppException {
      rethrow;
    } catch (_, stackTrace) {
      Error.throwWithStackTrace(const FetchException(), stackTrace);
    }
  }
}
