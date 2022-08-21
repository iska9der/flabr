import 'package:equatable/equatable.dart';

class ArticleStatisticsModel extends Equatable {
  final int commentsCount;
  final int favoritesCount;
  final int readingCount;
  final int score;
  final int votesCount;

  const ArticleStatisticsModel({
    this.commentsCount = 0,
    this.favoritesCount = 0,
    this.readingCount = 0,
    this.score = 0,
    this.votesCount = 0,
  });

  factory ArticleStatisticsModel.fromMap(Map<String, dynamic> map) {
    return ArticleStatisticsModel(
      commentsCount: map['commentsCount'],
      favoritesCount: map['favoritesCount'],
      readingCount: map['readingCount'],
      score: map['score'],
      votesCount: map['votesCount'],
    );
  }

  static const empty = ArticleStatisticsModel();

  @override
  List<Object> get props => [
        commentsCount,
        favoritesCount,
        readingCount,
        score,
        votesCount,
      ];
}
