import 'package:equatable/equatable.dart';

import '../list_response_model.dart';
import 'publication_model.dart';

class PublicationListResponseCommon extends ListResponse<Publication>
    with EquatableMixin {
  const PublicationListResponseCommon({
    super.pagesCount = 1,
    super.ids = const [],
    super.refs = const [],
  });

  factory PublicationListResponseCommon.fromMap(Map<String, dynamic> map) {
    var idsMap = map['publicationIds'];
    Map refsMap = map['publicationRefs'];

    return PublicationListResponseCommon(
      pagesCount: map['pagesCount'] ?? 0,
      ids: List<String>.from(idsMap),
      refs:
          Map.from(
            refsMap,
          ).entries.map((e) => PublicationCommon.fromMap(e.value)).toList(),
    );
  }

  static const empty = PublicationListResponseCommon(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
