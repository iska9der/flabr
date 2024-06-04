import 'params.dart';

class PostListParams extends Params {
  const PostListParams({
    super.langArticles = 'ru',
    super.langUI = 'ru',
    super.page = '',
    this.flow,
    this.sort,
    this.period,
    this.score = '',
  });

  final String? flow;

  /// Sorting
  final String? sort;
  final String? period;
  final String score;

  @override
  String toQueryString() {
    String? sortParam = sort != null ? '&sort=$sort' : '';

    String postsParam = '';
    if (flow != null) {
      sortParam = '';
      postsParam = '&flowPosts=true';
    } else {
      postsParam = '&posts=true';
    }

    String flowParam = flow != null ? '&flow=$flow' : '';
    String periodParam = period != null ? '&period=$period' : '';
    String scoreParam = score.isNotEmpty ? '&score=$score' : '';

    return 'fl=$langArticles&hl=$langUI$flowParam$postsParam$sortParam$periodParam$scoreParam&page=$page';
  }

  @override
  List<Object?> get props => [
        ...super.props,
        flow,
        sort,
        period,
        score,
      ];
}
