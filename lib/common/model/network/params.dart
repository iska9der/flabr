import 'package:equatable/equatable.dart';

abstract class Params extends Equatable {
  /// Язык постов
  /// перечисляется через запятую
  final String fl;

  /// Язык интерфейса
  final String hl;

  const Params({
    this.fl = 'ru',
    this.hl = 'ru',
  });

  Map<String, dynamic> toMap();

  static fromMap(map) {}
}
