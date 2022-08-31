import 'package:equatable/equatable.dart';

class HubStatisticsModel extends Equatable {
  const HubStatisticsModel({
    this.subscribersCount = 0,
    this.rating = 0.0,
    this.authorsCount = 0,
    this.postsCount = 0,
  });

  final int subscribersCount;
  final double rating;
  final int authorsCount;
  final int postsCount;

  factory HubStatisticsModel.fromMap(Map<String, dynamic> map) {
    return HubStatisticsModel(
      subscribersCount: map['subscribersCount'] as int,
      rating: double.parse(map['rating'].toString()),
      authorsCount: map['authorsCount'] as int,
      postsCount: map['postsCount'] as int,
    );
  }

  static const HubStatisticsModel empty = HubStatisticsModel();
  bool get isEmpty => this == empty;

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        subscribersCount,
        rating,
        authorsCount,
        postsCount,
      ];
}
