import '../../../../common/model/network/params.dart';

class FeedListParams extends Params {
  const FeedListParams({
    super.langArticles = 'ru',
    super.langUI = 'ru',
    super.page = '',
    this.complexity = 'all',
    this.score = 'all',
  });

  final String complexity;
  final String score;

  @override
  String toQueryString() {
    /// TODO: parse filter
    String filterParams = '';
    // if (filterParams.isNotEmpty) {
    // filterParams += '&types[0]=articles&types[1]=posts&types[2]=news';
    filterParams += '&complexity=$complexity&score=$score';
    // }

    return 'myFeed=true&fl=$langArticles&hl=$langUI$filterParams&page=$page';
  }

  @override
  List<Object?> get props => [
        ...super.props,
        complexity,
        score,
      ];
}
