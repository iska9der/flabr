import '../../../../common/model/network/params.dart';
import '../sort/date_period_enum.dart';

class ArticlesParams extends Params {
  const ArticlesParams({
    super.fl = 'ru',
    super.hl = 'ru',
    this.news,
    this.flow,
    this.custom,
    super.page = '',
    this.sort,
    this.period,
    this.score,
  });

  final String? news;
  final String? flow;
  final String? custom;

  /// Sorting
  final String? sort;
  final DatePeriodEnum? period;
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
      'period': period != null ? period!.name : null,
      'score': score,
    };
  }

  @override
  factory ArticlesParams.fromMap(Map<String, dynamic> map) {
    return ArticlesParams(
      fl: map['fl'] as String,
      hl: map['hl'] as String,
      news: map['news'] as String,
      flow: map['flow'] as String,
      custom: map['custom'] as String,
      page: map['page'] as String,
      sort: map['sort'] as String,
      period: DatePeriodEnum.fromString(map['period']),
      score: map['score'] as String,
    );
  }

  @override
  String toQueryString() {
    throw UnimplementedError();
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
