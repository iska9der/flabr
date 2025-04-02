import 'dart:collection';

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
    final idsMap = List<String>.from(map['companyIds'] ?? []);
    final refsMap = Map<String, dynamic>.from(map['companyRefs'] ?? {});

    return CompanyListResponse(
      pagesCount: map['pagesCount'] ?? 1,
      ids: UnmodifiableListView(idsMap),
      refs: UnmodifiableListView(
        refsMap.entries.map((e) => Company.fromMap(e.value)),
      ),
    );
  }

  static const empty = CompanyListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object?> get props => [pagesCount, ids, refs];
}
