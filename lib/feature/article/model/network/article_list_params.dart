import '../../../../common/model/network/params.dart';

class ArticleListParams extends Params {
  const ArticleListParams({
    super.langArticles = 'ru',
    super.langUI = 'ru',
    super.page = '',
    this.news = false,
    this.flow,
    this.custom,
    this.sort,
    this.period,
    this.score = '',
  });

  final bool news;
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

    String newsParam = '';
    if (news) {
      sortParam = '';
      if (flow != null) {
        newsParam = '&flowNews=true';
      } else {
        newsParam = '&news=true';
      }
    }

    String flowParam = flow != null ? '&flow=$flow' : '';
    String periodParam = period != null ? '&period=$period' : '';
    String scoreParam = score.isNotEmpty ? '&score=$score' : '';
    String customParam = custom != null ? '&custom=$custom' : '';

    return 'fl=$langArticles&hl=$langUI$flowParam$customParam$newsParam$sortParam$periodParam$scoreParam&page=$page';
  }

  @override
  List<Object?> get props => [
        ...super.props,
        news,
        flow,
        custom,
        sort,
        period,
        score,
      ];
}
