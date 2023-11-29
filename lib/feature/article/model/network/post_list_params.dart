import '../../../../common/model/network/params.dart';

class PostListParams extends Params {
  const PostListParams({
    super.langArticles = 'ru',
    super.langUI = 'ru',
    super.page = '',
    this.flow,
    this.custom,
    this.sort,
    this.period,
    this.score = '',
  });

  final String? flow;

  /// 'true', когда нужно получить "мою ленту"
  final String? custom;

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
    String customParam = custom != null ? '&custom=$custom' : '';

    return 'fl=$langArticles&hl=$langUI$flowParam$customParam$postsParam$sortParam$periodParam$scoreParam&page=$page';
  }

  @override
  List<Object?> get props => [
        ...super.props,
        flow,
        custom,
        sort,
        period,
        score,
      ];
}
