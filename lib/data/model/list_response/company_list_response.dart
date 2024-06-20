import 'package:equatable/equatable.dart';

import '../company/company_model.dart';
import 'list_response_model.dart';

class CompanyListResponse extends ListResponse with EquatableMixin {
  const CompanyListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    List<Company> super.refs = const [],
  });

  @override
  List<Company> get refs => super.refs as List<Company>;

  @override
  CompanyListResponse copyWith({
    int? pagesCount,
    List<String>? ids,
    List<dynamic>? refs,
  }) {
    return CompanyListResponse(
      pagesCount: pagesCount ?? this.pagesCount,
      ids: ids ?? this.ids,
      refs: List<Company>.from((refs ?? this.refs)),
    );
  }

  factory CompanyListResponse.fromMap(Map<String, dynamic> map) {
    var idsMap = map['companyIds'];
    Map refsMap = map['companyRefs'];

    return CompanyListResponse(
      pagesCount: map['pagesCount'] ?? 1,
      ids: List<String>.from(idsMap),
      refs: Map.from(refsMap)
          .entries
          .map((e) => Company.fromMap(e.value))
          .toList(),
    );
  }

  static const empty = CompanyListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object?> get props => [pagesCount, ids, refs];
}
