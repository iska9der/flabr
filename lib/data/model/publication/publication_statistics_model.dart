import 'package:equatable/equatable.dart';

class PublicationStatistics extends Equatable {
  const PublicationStatistics({
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

  factory PublicationStatistics.fromMap(Map<String, dynamic> map) {
    return PublicationStatistics(
      commentsCount: map['commentsCount'],
      favoritesCount: map['favoritesCount'],
      readingCount: map['readingCount'],
      score: map['score'],
      votesCount: map['votesCount'],
    );
  }

  static const empty = PublicationStatistics();

  @override
  List<Object> get props => [
        commentsCount,
        favoritesCount,
        readingCount,
        score,
        votesCount,
      ];
}
