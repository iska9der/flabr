import '../../../../common/model/network/params.dart';

class CommentListParams extends Params {
  const CommentListParams({
    super.langArticles,
    super.langUI,
    required this.articleId,
  });

  final String articleId;

  @override
  String toQueryString() {
    return '/articles/$articleId/comments/?fl=$langArticles&hl=$langUI';
  }

  @override
  List<Object?> get props => [langArticles, langUI, articleId];
}
