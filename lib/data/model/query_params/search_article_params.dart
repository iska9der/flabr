import 'params.dart';
import 'search_params.dart';

class SearchArticleParams extends Params implements SearchParamsFactory {
  const SearchArticleParams({
    super.langArticles,
    super.langUI,
    super.page,
    required this.query,
    required this.order,
  });

  final String query;
  final String order;

  @override
  String toQueryString() {
    return '/articles/?query=$query&order=$order&fl=$langArticles&hl=$langUI&page=$page';
  }
}
