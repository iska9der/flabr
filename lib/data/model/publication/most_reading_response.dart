import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../list_response_model.dart';
import 'publication_model.dart';

class MostReadingResponse extends ListResponse<PublicationCommon>
    with EquatableMixin {
  const MostReadingResponse({
    super.pagesCount = 1,
    super.ids = const [],
    super.refs = const [],
  });

  factory MostReadingResponse.fromMap(Map<String, dynamic> map) {
    final idsMap = List<String>.from(map['articleIds'] ?? map['newsIds'] ?? []);
    final refsMap = Map<String, dynamic>.from(
      map['articleRefs'] ?? map['newsRefs'] ?? {},
    );

    return MostReadingResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: UnmodifiableListView(idsMap),
      refs: UnmodifiableListView(
        refsMap.entries.map((e) => PublicationCommon.fromMap(e.value)),
      ),
    );
  }

  static const empty = MostReadingResponse(pagesCount: 0);
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
