import 'package:equatable/equatable.dart';

import '../list_response_model.dart';
import 'company_model.dart';

class CompanyListResponse extends ListResponse<Company> with EquatableMixin {
  const CompanyListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    super.refs = const [],
  });

  factory CompanyListResponse.fromMap(Map<String, dynamic> map) {
    var idsMap = map['companyIds'];
    Map refsMap = map['companyRefs'];

    return CompanyListResponse(
      pagesCount: map['pagesCount'] ?? 1,
      ids: List<String>.from(idsMap),
      refs:
          Map.from(
            refsMap,
          ).entries.map((e) => Company.fromMap(e.value)).toList(),
    );
  }

  static const empty = CompanyListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object?> get props => [pagesCount, ids, refs];
}
