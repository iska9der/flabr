import 'package:equatable/equatable.dart';

import '../hub/hub_model.dart';
import 'list_response_model.dart';

class HubListResponse extends ListResponse with EquatableMixin {
  const HubListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    List<Hub> super.refs = const [],
  });

  @override
  List<Hub> get refs => super.refs as List<Hub>;

  @override
  HubListResponse copyWith({
    int? pagesCount,
    List<String>? ids,
    List<dynamic>? refs,
  }) {
    return HubListResponse(
      pagesCount: pagesCount ?? this.pagesCount,
      ids: ids ?? this.ids,
      refs: List<Hub>.from((refs ?? this.refs)),
    );
  }

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
  get isEmpty => this == empty;

  @override
  List<Object?> get props => [pagesCount, ids, refs];
}
