import '../../../../common/model/network/params.dart';
import 'search_params.dart';

class SearchCompanyParams extends Params implements SearchParamsFactory {
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
    return '/companies/search?q=$query&sort=$order&order=$order&fl=$langArticles&hl=$langUI&page=$page';
  }
}
