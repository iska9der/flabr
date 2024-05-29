import 'package:equatable/equatable.dart';

import '../../../../common/model/network/list_response.dart';
import '../publication/publication.dart';

class FeedListResponse extends ListResponse with EquatableMixin {
  const FeedListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    List<Publication> super.refs = const [],
  });

  @override
  List<Publication> get refs => super.refs as List<Publication>;

  @override
  FeedListResponse copyWith({
    int? pagesCount,
    List<String>? ids,
    List<dynamic>? refs,
  }) {
    return FeedListResponse(
      pagesCount: pagesCount ?? this.pagesCount,
      ids: ids ?? this.ids,
      refs: List<Publication>.from((refs ?? this.refs)),
    );
  }

  factory FeedListResponse.fromMap(Map<String, dynamic> map) {
    var idsMap = map['publicationIds'];
    Map refsMap = map['publicationRefs'];

    return FeedListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: List<String>.from(idsMap),
      refs: Map.from(refsMap)
          .entries
          .map((e) => Publication.fromMap(e.value))
          .toList(),
    );
  }

  static const empty = FeedListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
