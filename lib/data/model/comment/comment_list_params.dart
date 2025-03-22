import '../query_params_model.dart';

class CommentListParams extends QueryParams {
  const CommentListParams({super.langArticles, super.langUI});

  @override
  String toQueryString() {
    return '?fl=$langArticles&hl=$langUI';
  }

  @override
  List<Object?> get props => [langArticles, langUI];
}
