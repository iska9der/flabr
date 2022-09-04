import 'package:equatable/equatable.dart';

class Params extends Equatable {
  const Params({
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

  Map<String, dynamic> toMap() {
    return {
      'fl': langArticles,
      'hl': langUI,
      'page': page,
    };
  }

  factory Params.fromMap(map) {
    return Params(
      langArticles: map['fl'] ?? 'ru',
      langUI: map['hl'] ?? 'ru',
      page: map['page'] ?? '',
    );
  }

  String toQueryString() {
    return 'fl=$langArticles&hl=$langUI&page=$page';
  }

  @override
  List<Object?> get props => [langArticles, langUI, page];
}
