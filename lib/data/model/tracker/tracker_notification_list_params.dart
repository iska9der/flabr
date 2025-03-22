import '../query_params_model.dart';

class TrackerNotificationListParams extends QueryParams {
  const TrackerNotificationListParams({
    super.page = '1',
    this.perPage = '30',
    required this.category,
  });

  final String perPage;
  final String category;

  @override
  String toQueryString() {
    return 'page_num=$page&per_page=$perPage&category=$category';
  }

  @override
  List<Object?> get props => [...super.props, perPage];
}
