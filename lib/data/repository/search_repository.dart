import 'dart:async';

import 'package:injectable/injectable.dart';

import '../exception/exception.dart';
import '../model/company/company.dart' show CompanyListResponse;
import '../model/hub/hub.dart' show HubListResponse;
import '../model/language/language.dart';
import '../model/list_response_model.dart';
import '../model/publication/publication.dart';
import '../model/search/search.dart';
import '../model/user/user_list_response.dart' show UserListResponse;
import '../service/service.dart';

@LazySingleton()
class SearchRepository {
  const SearchRepository(SearchService service) : _service = service;

  final SearchService _service;

  Future<ListResponse> fetch({
    required Language langUI,
    required List<Language> langArticles,
    required String query,
    required SearchTarget target,
    required SearchOrder order,
    required int page,
  }) async {
    var raw = await _service.fetch(
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
      query: query,
      target: target,
      order: order.name,
      page: page,
    );

    switch (target) {
      case SearchTarget.posts:
        final response = PublicationCommonListResponse.fromMap(raw);
        _sortArticles(order, response);
        return response;
      case SearchTarget.hubs:
        return HubListResponse.fromMap(raw);
      case SearchTarget.companies:
        return CompanyListResponse.fromMap(raw);
      case SearchTarget.users:
        return UserListResponse.fromMap(raw);
      case SearchTarget.comments:
        throw ValueException('Не реализовано');
    }
  }

  void _sortArticles(
    SearchOrder order,
    PublicationCommonListResponse response,
  ) {
    if (order == SearchOrder.date) {
      response.refs.sort((a, b) => b.timePublished.compareTo(a.timePublished));
    } else if (order == SearchOrder.rating) {
      response.refs.sort(
        (a, b) => b.statistics.score.compareTo(a.statistics.score),
      );
    }
  }
}
