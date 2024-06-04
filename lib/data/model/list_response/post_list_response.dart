import 'package:equatable/equatable.dart';

import '../publication/publication.dart';
import 'list_response.dart';

class PostListResponse extends ListResponse with EquatableMixin {
  const PostListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    List<PublicationPost> super.refs = const [],
  });

  @override
  List<PublicationPost> get refs => super.refs as List<PublicationPost>;

  @override
  PostListResponse copyWith({
    int? pagesCount,
    List<String>? ids,
    List<dynamic>? refs,
  }) {
    return PostListResponse(
      pagesCount: pagesCount ?? this.pagesCount,
      ids: ids ?? this.ids,
      refs: List<PublicationPost>.from((refs ?? this.refs)),
    );
  }

  factory PostListResponse.fromMap(Map<String, dynamic> map) {
    var idsMap = map['publicationIds'];
    Map refsMap = map['publicationRefs'];

    return PostListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: List<String>.from(idsMap),
      refs: Map.from(refsMap)
          .entries
          .map((e) => PublicationPost.fromMap(e.value))
          .toList(),
    );
  }

  static const empty = PostListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
