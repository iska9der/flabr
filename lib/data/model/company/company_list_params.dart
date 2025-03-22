// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../query_params_model.dart';

class CompanyListParams extends QueryParams with EquatableMixin {
  const CompanyListParams({
    super.page,
    super.langArticles,
    super.langUI,
    this.order = 'rating',
    this.orderDirection = 'desc',
  });

  final String order;
  final String orderDirection;

  @override
  String toQueryString() {
    return '/companies/?page=$page&order=$order&orderDirection=$orderDirection&fl=$langArticles&hl=$langUI';
  }

  @override
  List<Object?> get props => [...super.props, order, orderDirection];
}
