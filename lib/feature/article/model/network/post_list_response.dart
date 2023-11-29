import 'package:equatable/equatable.dart';

import '../article_model.dart';
import '/common/model/network/list_response.dart';

class PostListResponse extends ListResponse with EquatableMixin {
  const PostListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    List<ArticleModel> super.refs = const [],
  });

  @override
  List<ArticleModel> get refs => super.refs as List<ArticleModel>;

  @override
  PostListResponse copyWith({
    int? pagesCount,
    List<String>? ids,
    List<dynamic>? refs,
  }) {
    return PostListResponse(
      pagesCount: pagesCount ?? this.pagesCount,
      ids: ids ?? this.ids,
      refs: List<ArticleModel>.from((refs ?? this.refs)),
    );
  }

  factory PostListResponse.fromMap(Map<String, dynamic> map) {
    var idsMap = map['threadIds'];
    Map refsMap = map['threadRefs'];

    return PostListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: List<String>.from(idsMap),
      refs: Map.from(refsMap)
          .entries
          .map((e) => ArticleModel.fromMap(e.value))
          .toList(),
    );
  }

  static const empty = PostListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
