
part of 'publication.dart';

class PublicationPostListParams extends QueryParams {
  const PublicationPostListParams({
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

    String flowParam = flow != null ? 'flow=$flow' : '';
    String periodParam = period != null ? '&period=$period' : '';
    String scoreParam = score.isNotEmpty ? '&score=$score' : '';

    return '$flowParam$postsParam$sortParam$periodParam$scoreParam&page=$page';
  }

  @override
  List<Object?> get props => [...super.props, flow, sort, period, score];
}
