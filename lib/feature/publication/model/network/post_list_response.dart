import 'package:equatable/equatable.dart';

import '../post/post_model.dart';
import '/common/model/network/list_response.dart';

class PostListResponse extends ListResponse with EquatableMixin {
  const PostListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    List<PostModel> super.refs = const [],
  });

  @override
  List<PostModel> get refs => super.refs as List<PostModel>;

  @override
  PostListResponse copyWith({
    int? pagesCount,
    List<String>? ids,
    List<dynamic>? refs,
  }) {
    return PostListResponse(
      pagesCount: pagesCount ?? this.pagesCount,
      ids: ids ?? this.ids,
      refs: List<PostModel>.from((refs ?? this.refs)),
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
          .map((e) => PostModel.fromMap(e.value))
          .toList(),
    );
  }

  static const empty = PostListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
