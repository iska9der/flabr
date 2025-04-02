import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../list_response_model.dart';
import 'publication_model.dart';

class PublicationCommonListResponse extends ListResponse<Publication>
    with EquatableMixin {
  const PublicationCommonListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    super.refs = const [],
  });

  factory PublicationCommonListResponse.fromMap(Map<String, dynamic> map) {
    final idsMap = List<String>.from(map['publicationIds'] ?? []);
    final refsMap = Map<String, dynamic>.from(map['publicationRefs'] ?? {});

    return PublicationCommonListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: UnmodifiableListView(idsMap),
      refs: UnmodifiableListView(
        refsMap.entries.map((e) => PublicationCommon.fromMap(e.value)),
      ),
    );
  }

  static const empty = PublicationCommonListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
