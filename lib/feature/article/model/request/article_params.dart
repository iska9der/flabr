import '../../../../common/exception/value_exception.dart';
import '../../../../common/model/make_request/params.dart';
import '../sort/date_period_enum.dart';
import '../sort/sort_enum.dart';

class ArticlesParams extends Params {
  final String? news;
  final String? flow;
  final String? custom;
  final String? page;

  /// Sorting
  final SortEnum? sort;
  final DatePeriodEnum? period;
  final String? score;

  ArticlesParams({
    super.fl = 'ru',
    super.hl = 'ru',
    this.news,
    this.flow,
    this.custom,
    this.page,
    this.sort,
    this.period,
    this.score,
  }) {
    if (sort == SortEnum.date && period is! DatePeriodEnum) {
      throw ValueException('Нужно указать период сортировки');
    }
    if (sort == SortEnum.rating && score == null) {
      throw ValueException('Нужно указать рейтинг сортировки');
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'fl': fl,
      'hl': hl,
      'news': news,
      'flow': flow,
      'custom': custom,
      'page': page,
      'sort': sort != null ? sort!.name : null,
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
      sort: SortEnum.fromString(map['sort']),
      period: DatePeriodEnum.fromString(map['period']),
      score: map['score'] as String,
    );
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
