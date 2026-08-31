import 'dart:async';

import 'package:injectable/injectable.dart';

import '../model/list_response_model.dart';
import '../model/publication/publication.dart';
import '../model/search/search.dart';
import '../service/service.dart';

@LazySingleton()
class SearchRepository {
  const SearchRepository(SearchService service) : _service = service;

  final SearchService _service;

  Future<ListResponse<dynamic>> fetch({
    required String query,
    required SearchTarget target,
    required SearchOrder order,
    required int page,
  }) async {
    final response = await _service.fetch(
      query: query,
      target: target,
      order: order.name,
      page: page,
    );

    if (target != SearchTarget.posts) {
      return response;
    }

    final publicationResponse = response as ListResponse<Publication>;
    final sortedList = _sortPublications(order, publicationResponse);

    return publicationResponse.copyWith(refs: sortedList);
  }

  List<Publication> _sortPublications(
    SearchOrder order,
    ListResponse<Publication> response,
  ) {
    final refs = [...response.refs];

    if (order == SearchOrder.date) {
      refs.sort((a, b) => b.timePublished.compareTo(a.timePublished));
    } else if (order == SearchOrder.rating) {
      refs.sort((a, b) => b.statistics.score.compareTo(a.statistics.score));
    }

    return refs;
  }
}
