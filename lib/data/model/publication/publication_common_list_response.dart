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
    var idsMap = map['publicationIds'];
    Map refsMap = map['publicationRefs'];

    return PublicationCommonListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: List<String>.from(idsMap),
      refs:
          Map.from(
            refsMap,
          ).entries.map((e) => PublicationCommon.fromMap(e.value)).toList(),
    );
  }

  static const empty = PublicationCommonListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
