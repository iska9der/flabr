import 'package:equatable/equatable.dart';

class Params extends Equatable {
  const Params({
    this.fl = 'ru',
    this.hl = 'ru',
    this.page = '',
  });

  /// Язык постов
  ///
  /// перечисляется через запятую
  final String fl;

  /// Язык интерфейса
  final String hl;

  final String page;

  Map<String, dynamic> toMap() {
    return {
      'fl': fl,
      'hl': hl,
      'page': page,
    };
  }

  factory Params.fromMap(map) {
    return Params(
      fl: map['fl'] ?? 'ru',
      hl: map['hl'] ?? 'ru',
      page: map['page'] ?? '',
    );
  }

  String toQueryString() {
    return 'fl=$fl&hl=$hl&page=$page';
  }

  @override
  List<Object?> get props => [fl, hl, page];
}
