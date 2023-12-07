import 'package:equatable/equatable.dart';

import '../../../../common/model/network/list_response.dart';
import '../article_model.dart';

class ArticleListResponse extends ListResponse with EquatableMixin {
  const ArticleListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    List<ArticleModel> super.refs = const [],
  });

  @override
  List<ArticleModel> get refs => super.refs as List<ArticleModel>;

  @override
  ArticleListResponse copyWith({
    int? pagesCount,
    List<String>? ids,
    List<dynamic>? refs,
  }) {
    return ArticleListResponse(
      pagesCount: pagesCount ?? this.pagesCount,
      ids: ids ?? this.ids,
      refs: List<ArticleModel>.from((refs ?? this.refs)),
    );
  }

  factory ArticleListResponse.fromMap(Map<String, dynamic> map) {
    var idsMap = map['publicationIds'];
    Map refsMap = map['publicationRefs'];

    return ArticleListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: List<String>.from(idsMap),
      refs: Map.from(refsMap)
          .entries
          .map((e) => ArticleModel.fromMap(e.value))
          .toList(),
    );
  }

  static const empty = ArticleListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
