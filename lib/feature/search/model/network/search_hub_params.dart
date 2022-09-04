import '../../../../common/model/network/params.dart';
import 'search_params.dart';

class SearchHubParams extends Params implements SearchParamsFactory {
  const SearchHubParams({
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
    return '/hubs/search?q=$query&target_type=hubs&order=$order&fl=$langArticles&hl=$langUI&page=$page';
  }
}
