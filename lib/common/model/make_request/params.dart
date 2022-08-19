import 'package:equatable/equatable.dart';

abstract class Params extends Equatable {
  final String fl;
  final String hl;

  const Params({
    this.fl = 'ru',
    this.hl = 'ru',
  });

  Map<String, dynamic> toMap();

  static fromMap(map) {}
}
