import 'package:equatable/equatable.dart';

class Params extends Equatable {
  final String fl;
  final String hl;
  final String? news;
  final String? flow;
  final String? custom;
  final String? page;

  /// Sorting
  final String? sort;
  final String? period;
  final String? score;

  const Params({
    this.fl = 'ru',
    this.hl = 'ru',
    this.news,
    this.flow,
    this.custom,
    this.page,
    this.sort,
    this.period,
    this.score,
  });

  Map<String, dynamic> toMap() {
    return {
      'fl': fl,
      'hl': hl,
      'news': news,
      'flow': flow,
      'custom': custom,
      'page': page,
      'sort': sort,
      'period': period,
      'score': score,
    };
  }

  factory Params.fromMap(Map<String, dynamic> map) {
    return Params(
      fl: map['fl'] as String,
      hl: map['hl'] as String,
      news: map['news'] as String,
      flow: map['flow'] as String,
      custom: map['custom'] as String,
      page: map['page'] as String,
      sort: map['sort'] as String,
      period: map['period'] as String,
      score: map['score'] as String,
    );
  }

  @override
  List<Object?> get props => [
        fl,
        hl,
        news,
        flow,
        custom,
        page,
        sort,
        period,
        score,
      ];
}
