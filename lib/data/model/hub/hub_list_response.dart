import 'dart:collection';

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
    final idsMap = List<String>.from(map['hubIds'] ?? []);
    final refsMap = Map<String, dynamic>.from(map['hubRefs'] ?? {});

    return HubListResponse(
      pagesCount: map['pagesCount'] ?? 1,
      ids: UnmodifiableListView(idsMap),
      refs: UnmodifiableListView(
        refsMap.entries.map((e) => Hub.fromMap(e.value)),
      ),
    );
  }

  static const empty = HubListResponse(pagesCount: 0);

  @override
  List<Object?> get props => [pagesCount, ids, refs];
}
