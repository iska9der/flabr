import '../query_params_model.dart';
import 'search_params.dart';

class SearchCompanyParams extends QueryParams implements SearchParamsFactory {
  const SearchCompanyParams({
    required this.query,
    required this.order,
    super.langArticles,
    super.langUI,
    super.page,
  });

  final String query;
  final String order;

  @override
  String toQueryString() {
    return '/companies/search?q=$query&sort=$order'
        '&order=$order&fl=$langArticles&hl=$langUI&page=$page';
  }
}
