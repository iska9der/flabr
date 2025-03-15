import 'package:freezed_annotation/freezed_annotation.dart';

part 'publication_statistics_model.freezed.dart';
part 'publication_statistics_model.g.dart';

@freezed
class PublicationStatistics with _$PublicationStatistics {
  const PublicationStatistics._();

  const factory PublicationStatistics({
    @Default(0) int commentsCount,
    @Default(0) int favoritesCount,
    @Default(0) int readingCount,
    @Default(0) int score,

    /// Количество голосов за публикацию
    @Default(0) int votesCount,

    /// Количество голосов за публикацию с плюсом
    @Default(0) int votesCountPlus,

    /// Количество голосов за публикацию с минусом
    @Default(0) int votesCountMinus,
  }) = _PublicationStatistics;

  factory PublicationStatistics.fromJson(Map<String, dynamic> json) =>
      _$PublicationStatisticsFromJson(json);

  static const empty = PublicationStatistics();
}
