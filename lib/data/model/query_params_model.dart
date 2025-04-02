import 'package:equatable/equatable.dart';

class QueryParams extends Equatable {
  const QueryParams({
    this.langArticles = 'ru',
    this.langUI = 'ru',
    this.page = '',
  });

  /// Язык постов
  ///
  /// `fl` на хабре
  ///
  /// перечисляется через запятую
  final String langArticles;

  /// Язык интерфейса
  ///
  /// `hl` на хабре
  final String langUI;

  final String page;

  factory QueryParams.fromMap(Map<String, dynamic> map) {
    return QueryParams(
      langArticles: map['fl'] ?? 'ru',
      langUI: map['hl'] ?? 'ru',
      page: map['page'] ?? '',
    );
  }

  String toQueryString() {
    return 'fl=$langArticles&hl=$langUI&page=$page';
  }

  Map<String, dynamic> toMap() {
    final asString = toQueryString();
    final uri = Uri(query: asString);

    return uri.queryParameters;
  }

  @override
  List<Object?> get props => [langArticles, langUI, page];
}
