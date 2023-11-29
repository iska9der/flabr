import '../../../../common/model/network/params.dart';

class CommentListParams extends Params {
  const CommentListParams({
    super.langArticles,
    super.langUI,
  });

  @override
  String toQueryString() {
    return '?fl=$langArticles&hl=$langUI';
  }

  @override
  List<Object?> get props => [langArticles, langUI];
}
