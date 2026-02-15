import 'package:equatable/equatable.dart';

class CompanyStatistics with EquatableMixin {
  const CompanyStatistics({
    this.subscribersCount = 0,
    this.rating = 0.0,
    this.invest = 0,
  });

  final int subscribersCount;
  final double rating;

  /// Инвестировано (куда? в хабы?)
  final int? invest;

  factory CompanyStatistics.fromMap(Map<String, dynamic> map) {
    return CompanyStatistics(
      subscribersCount: map['subscribersCount'] as int,
      rating: double.parse(map['rating'].toString()),
      invest: map['invest'] as int?,
    );
  }

  static const CompanyStatistics empty = CompanyStatistics();

  @override
  List<Object?> get props => [subscribersCount, rating, invest];
}
