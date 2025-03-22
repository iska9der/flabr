import 'package:equatable/equatable.dart';

import '../list_response_model.dart';
import 'publication_model.dart';

class FeedListResponse extends ListResponse<Publication> with EquatableMixin {
  const FeedListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    super.refs = const [],
  });

  factory FeedListResponse.fromMap(Map<String, dynamic> map) {
    var idsMap = map['publicationIds'];
    Map refsMap = map['publicationRefs'];

    return FeedListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: List<String>.from(idsMap),
      refs:
          Map.from(
            refsMap,
          ).entries.map((e) => Publication.fromMap(e.value)).toList(),
    );
  }

  static const empty = FeedListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
