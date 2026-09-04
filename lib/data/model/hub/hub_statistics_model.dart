import 'package:equatable/equatable.dart';

class HubStatistics with Equatable {
  const HubStatistics({
    this.subscribersCount = 0,
    this.rating = 0.0,
    this.authorsCount = 0,
    this.postsCount = 0,
    this.reach,
  });

  final int subscribersCount;
  final double rating;
  final int authorsCount;
  final int postsCount;

  /// Охват за 30 дней
  final String? reach;

  factory HubStatistics.fromJson(Map<String, dynamic> map) {
    return HubStatistics(
      subscribersCount: map['subscribersCount'] as int,
      rating: double.parse(map['rating'].toString()),
      authorsCount: map['authorsCount'] as int,
      postsCount: map['postsCount'] as int,
      reach: map['reach'] as String?,
    );
  }

  static const HubStatistics empty = HubStatistics();
  bool get isEmpty => this == empty;

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    subscribersCount,
    rating,
    authorsCount,
    postsCount,
    reach,
  ];
}
