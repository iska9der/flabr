import 'params.dart';

class PublicationListParams extends Params {
  const PublicationListParams({
    super.langArticles = 'ru',
    super.langUI = 'ru',
    super.page = '',
    this.news = false,
    this.flow,
    this.sort,
    this.period,
    this.score = '',
  });

  final bool news;
  final String? flow;

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

    return 'fl=$langArticles&hl=$langUI$flowParam$newsParam$sortParam$periodParam$scoreParam&page=$page';
  }

  @override
  List<Object?> get props => [
        ...super.props,
        news,
        flow,
        sort,
        period,
        score,
      ];
}
