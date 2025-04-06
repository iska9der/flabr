import '../query_params_model.dart';
import 'search_params.dart';

class SearchHubParams extends QueryParams implements SearchParamsFactory {
  const SearchHubParams({required this.query, required this.order, super.page});

  final String query;
  final String order;

  @override
  String toQueryString() {
    return '/hubs/search?q=$query&target_type=hubs'
        '&order=$order&page=$page';
  }
}
