part of 'publication_vote_bloc.dart';

@freezed
abstract class PublicationVoteState with _$PublicationVoteState {
  const factory PublicationVoteState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    String? error,

    /// Идентификатор публикации
    required String id,

    /// Рейтинг публикации
    @Default(0) int score,

    /// Можно ли голосовать
    @Default(PublicationVoteAction.empty) PublicationVoteAction actionPlus,
    @Default(PublicationVoteAction.empty) PublicationVoteAction actionMinus,

    /// Всего голосов
    @Default(0) int votesCount,

    /// Всего плюсов
    @Default(0) int votesCountPlus,

    /// Всего минусов
    @Default(0) int votesCountMinus,

    /// Мой голос (-1 или 1)
    int? vote,
  }) = _PublicationVoteState;
}
