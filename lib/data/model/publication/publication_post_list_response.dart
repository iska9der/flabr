import 'package:equatable/equatable.dart';

import '../list_response_model.dart';
import 'publication_model.dart';

class PublicationPostListResponse extends ListResponse<Publication>
    with EquatableMixin {
  const PublicationPostListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    super.refs = const [],
  });

  factory PublicationPostListResponse.fromMap(Map<String, dynamic> map) {
    var idsMap = map['publicationIds'];
    Map refsMap = map['publicationRefs'];

    return PublicationPostListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: List<String>.from(idsMap),
      refs:
          Map.from(
            refsMap,
          ).entries.map((e) => PublicationPost.fromMap(e.value)).toList(),
    );
  }

  static const empty = PublicationPostListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
