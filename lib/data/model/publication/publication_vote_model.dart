import 'package:freezed_annotation/freezed_annotation.dart';

part 'publication_vote_model.freezed.dart';
part 'publication_vote_model.g.dart';

@freezed
abstract class PublicationVote with _$PublicationVote {
  const PublicationVote._();

  const factory PublicationVote({
    int? value,
    String? voteTimeExpired,
  }) = _PublicationVote;

  factory PublicationVote.fromJson(Map<String, dynamic> json) =>
      _$PublicationVoteFromJson(json);

  static const empty = PublicationVote();
}

@freezed
abstract class PublicationVoteAction with _$PublicationVoteAction {
  const PublicationVoteAction._();

  const factory PublicationVoteAction({
    @Default(false) bool canVote,

    /// Исчерпан ли лимит выделенных на день голосов
    @Default(false) bool isChargeEnough,

    /// Достаточно ли очков профиля для голосования
    @Default(false) bool isKarmaEnough,

    /// Окончено ли голосование для этого публикации
    @Default(false) bool isVotingOver,
  }) = _PublicationVoteAction;

  factory PublicationVoteAction.fromJson(Map<String, dynamic> json) =>
      _$PublicationVoteActionFromJson(json);

  static const empty = PublicationVoteAction();
}
