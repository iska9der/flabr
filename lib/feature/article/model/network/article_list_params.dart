import '../../../../common/model/network/params.dart';

class ArticleListParams extends Params {
  const ArticleListParams({
    super.langArticles = 'ru',
    super.langUI = 'ru',
    this.news = false,
    this.flow,
    this.custom,
    super.page = '',
    this.sort,
    this.period,
    this.score,
  });

  final bool news;
  final String? flow;

  /// 'true', когда нужно получить "мою ленту"
  final String? custom;

  /// Sorting
  final String? sort;
  final String? period;
  final String? score;

  @override
  Map<String, dynamic> toMap() {
    return {
      'fl': langArticles,
      'hl': langUI,
      'news': news,
      'flow': flow,
      'custom': custom,
      'page': page,
      'sort': sort,
      'period': period,
      'score': score,
    };
  }

  @override
  String toQueryString() {
    String? lSort = sort != null ? '&sort=$sort' : '';

    String lNews = '';
    if (news) {
      lSort = '';
      if (flow != null) {
        lNews = '&flowNews=true';
      } else {
        lNews = '&news=true';
      }
    }

    String? lFlow = flow != null ? '&flow=$flow' : '';
    String? lPeriod = period != null ? '&period=$period' : '';
    String? lScore = score != null ? '&score=$score' : '';
    String? lCustom = custom != null ? '&custom=$custom' : '';

    return 'fl=$langArticles&hl=$langUI$lFlow$lCustom$lNews$lSort$lPeriod$lScore&page=$page';
  }

  @override
  List<Object?> get props => [
        langArticles,
        langUI,
        news,
        flow,
        custom,
        page,
        sort,
        period,
        score,
      ];
}
