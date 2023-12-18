import '../../../../common/model/network/params.dart';

class PublicationListParams extends Params {
  const PublicationListParams({
    super.langArticles = 'ru',
    super.langUI = 'ru',
    super.page = '',
    this.news = false,
    this.flow,
    this.feed,
    this.sort,
    this.period,
    this.score = '',
  });

  final bool news;
  final String? flow;

  /// 'true', когда нужно получить "мою ленту"
  final String? feed;

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
    String feedParam = feed != null ? '&myFeed=$feed' : '';
    if (feedParam.isNotEmpty) {
      feedParam += news ? '&types[0]=news' : '&types[0]=articles';
      feedParam += '&complexity=all&score=all';
      newsParam = '';
    }

    return 'fl=$langArticles&hl=$langUI$flowParam$feedParam$newsParam$sortParam$periodParam$scoreParam&page=$page';
  }

  @override
  List<Object?> get props => [
        ...super.props,
        news,
        flow,
        feed,
        sort,
        period,
        score,
      ];
}
