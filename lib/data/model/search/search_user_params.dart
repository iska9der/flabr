import '../query_params_model.dart';
import 'search_params.dart';

class SearchUserParams extends QueryParams implements SearchParamsFactory {
  const SearchUserParams({
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
    return '/users/search?q=$query&target_type=users'
        '&order=$order&fl=$langArticles&hl=$langUI&page=$page';
  }
}
