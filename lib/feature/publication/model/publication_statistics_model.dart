import 'package:equatable/equatable.dart';

class PublicationStatisticsModel extends Equatable {
  const PublicationStatisticsModel({
    this.commentsCount = 0,
    this.favoritesCount = 0,
    this.readingCount = 0,
    this.score = 0,
    this.votesCount = 0,
  });

  final int commentsCount;
  final int favoritesCount;
  final int readingCount;
  final int score;
  final int votesCount;

  factory PublicationStatisticsModel.fromMap(Map<String, dynamic> map) {
    return PublicationStatisticsModel(
      commentsCount: map['commentsCount'],
      favoritesCount: map['favoritesCount'],
      readingCount: map['readingCount'],
      score: map['score'],
      votesCount: map['votesCount'],
    );
  }

  static const empty = PublicationStatisticsModel();

  @override
  List<Object> get props => [
        commentsCount,
        favoritesCount,
        readingCount,
        score,
        votesCount,
      ];
}
