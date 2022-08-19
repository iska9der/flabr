import 'package:equatable/equatable.dart';

class ArticleStatistics extends Equatable {
  final int commentsCount;
  final int favoritesCount;
  final int readingCount;
  final int score;
  final int votesCount;

  const ArticleStatistics({
    required this.commentsCount,
    required this.favoritesCount,
    required this.readingCount,
    required this.score,
    required this.votesCount,
  });

  factory ArticleStatistics.fromMap(Map<String, dynamic> map) {
    return ArticleStatistics(
      commentsCount: map['commentsCount'],
      favoritesCount: map['favoritesCount'],
      readingCount: map['readingCount'],
      score: map['score'],
      votesCount: map['votesCount'],
    );
  }

  @override
  List<Object> get props => [
        commentsCount,
        favoritesCount,
        readingCount,
        score,
        votesCount,
      ];
}
