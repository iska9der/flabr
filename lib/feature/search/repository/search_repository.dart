import '../../../common/exception/value_exception.dart';
import '../../../common/model/network/list_response.dart';
import '../../../component/language.dart';
import '../../article/model/network/article_list_response.dart';
import '../../hub/model/network/hub_list_response.dart';
import '../../user/model/network/user_list_response.dart';
import '../model/search_order.dart';
import '../model/search_target.dart';
import '../service/search_service.dart';

class SearchRepository {
  const SearchRepository(SearchService service) : _service = service;

  final SearchService _service;

  Future<ListResponse> fetch({
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
    required String query,
    required SearchTarget target,
    required SearchOrder order,
    required int page,
  }) async {
    var raw = await _service.fetch(
      langUI: langUI.name,
      langArticles: encodeLangs(langArticles),
      query: query,
      target: target,
      order: order.name,
      page: page,
    );

    switch (target) {
      case SearchTarget.posts:
        final response = ArticleListResponse.fromMap(raw);
        _sortArticles(order, response);
        return response;
      case SearchTarget.hubs:
        return HubListResponse.fromMap(raw);
      case SearchTarget.companies:
        throw ValueException('Не реализовано');
      case SearchTarget.users:
        return UserListResponse.fromMap(raw);
      case SearchTarget.comments:
        throw ValueException('Не реализовано');
    }
  }

  void _sortArticles(SearchOrder order, ArticleListResponse response) {
    if (order == SearchOrder.date) {
      response.refs.sort((a, b) => b.timePublished.compareTo(
            a.timePublished,
          ));
    } else if (order == SearchOrder.rating) {
      response.refs.sort((a, b) => b.statistics.score.compareTo(
            a.statistics.score,
          ));
    }
  }
}
