import 'params_model.dart';

class TrackerPublicationParams extends Params {
  const TrackerPublicationParams({
    super.langArticles = 'ru',
    super.langUI = 'ru',
    super.page = '1',
    this.perPage = '30',
    this.byAuthor = false,
  });

  final String perPage;

  /// Если true, то получаем подраздел "Мои", иначе "Все"
  final bool byAuthor;

  @override
  String toQueryString() {
    return 'pageNum=$page&perPage=$perPage&byAuthor=$byAuthor';
  }

  @override
  List<Object?> get props => [
        ...super.props,
        perPage,
      ];
}
