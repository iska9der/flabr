import '../../../../common/model/network/params.dart';
import 'search_params.dart';

class SearchUserParams extends Params implements SearchParamsFactory {
  const SearchUserParams({
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
    return '/users/search?q=$query&target_type=users&order=$order&fl=$fl&hl=$hl&page=$page';
  }
}
