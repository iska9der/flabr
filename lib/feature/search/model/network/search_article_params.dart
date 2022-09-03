import '../../../../common/model/network/params.dart';
import 'search_params.dart';

class SearchArticleParams extends Params implements SearchParamsFactory {
  const SearchArticleParams({
    super.fl,
    super.hl,
    super.page,
    required this.query,
    required this.order,
  });

  final String query;
  final String order;

  @override
  String toQueryString() {
    return '/articles/?query=$query&order=$order&fl=$fl&hl=$hl&page=$page';
  }
}
