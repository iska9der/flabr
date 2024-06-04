import 'package:equatable/equatable.dart';

class CompanyStatisticsModel extends Equatable {
  const CompanyStatisticsModel({
    this.subscribersCount = 0,
    this.rating = 0.0,
    this.invest = 0,
  });

  final int subscribersCount;
  final double rating;

  /// Инвестировано (куда? в хабы?)
  final int? invest;

  factory CompanyStatisticsModel.fromMap(Map<String, dynamic> map) {
    return CompanyStatisticsModel(
      subscribersCount: map['subscribersCount'] as int,
      rating: double.parse(map['rating'].toString()),
      invest: map['invest'] as int?,
    );
  }

  static const CompanyStatisticsModel empty = CompanyStatisticsModel();
  bool get isEmpty => this == empty;

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        subscribersCount,
        rating,
        invest,
      ];
}
