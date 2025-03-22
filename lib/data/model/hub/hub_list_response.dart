import 'package:equatable/equatable.dart';

import '../list_response_model.dart';
import 'hub_model.dart';

class HubListResponse extends ListResponse<Hub> with EquatableMixin {
  const HubListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    super.refs = const [],
  });

  factory HubListResponse.fromMap(Map<String, dynamic> map) {
    var idsMap = map['hubIds'];
    Map refsMap = map['hubRefs'];

    return HubListResponse(
      pagesCount: map['pagesCount'] ?? 1,
      ids: List<String>.from(idsMap),
      refs: Map.from(refsMap).entries.map((e) => Hub.fromMap(e.value)).toList(),
    );
  }

  static const empty = HubListResponse(pagesCount: 0);

  @override
  List<Object?> get props => [pagesCount, ids, refs];
}
