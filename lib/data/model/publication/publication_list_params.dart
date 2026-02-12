
part of 'publication.dart';

class PublicationListParams extends QueryParams {
  const PublicationListParams({
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
    String flowParam = flow != null ? 'flow=$flow' : '';
    String newsParam = '';
    String sortParam = '';
    if (news) {
      newsParam = flow != null ? 'flowNews=true' : 'news=true';
    } else {
      sortParam = sort != null ? 'sort=$sort' : '';
    }

    String periodParam = period != null ? 'period=$period' : '';
    String scoreParam = score.isNotEmpty ? 'score=$score' : '';

    final params =
        [
          flowParam,
          newsParam,
          sortParam,
          periodParam,
          scoreParam,
        ].where((element) => element.isNotEmpty).toList();

    params.add('page=$page');

    final queryString = params.join('&');

    return queryString;
  }

  @override
  List<Object?> get props => [...super.props, news, flow, sort, period, score];
}
