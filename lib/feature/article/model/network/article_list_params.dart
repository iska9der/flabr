import '../../../../common/model/network/params.dart';

class ArticleListParams extends Params {
  const ArticleListParams({
    super.fl = 'ru',
    super.hl = 'ru',
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
  final String? custom;

  /// Sorting
  final String? sort;
  final String? period;
  final String? score;

  @override
  Map<String, dynamic> toMap() {
    return {
      'fl': fl,
      'hl': hl,
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
  factory ArticleListParams.fromMap(Map<String, dynamic> map) {
    return ArticleListParams(
      fl: map['fl'] as String,
      hl: map['hl'] as String,
      news: map['news'] ? map['news'] == 'true' : false,
      flow: map['flow'] as String,
      custom: map['custom'] as String,
      page: map['page'] as String,
      sort: map['sort'] as String,
      period: map['period'] as String,
      score: map['score'] as String,
    );
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

    return 'fl=$fl&hl=$hl$lFlow$lNews$lSort$lPeriod$lScore&page=$page';
  }

  @override
  List<Object?> get props => [
        fl,
        hl,
        news,
        flow,
        custom,
        page,
        sort,
        period,
        score,
      ];
}
