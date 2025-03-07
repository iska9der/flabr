import 'package:freezed_annotation/freezed_annotation.dart';

part 'publication_vote_model.freezed.dart';
part 'publication_vote_model.g.dart';

@freezed
class PublicationVoteModel with _$PublicationVoteModel {
  const PublicationVoteModel._();

  const factory PublicationVoteModel({
    @Default(false) bool canVote,

    /// Исчерпан ли лимит выделенных на день голосов
    @Default(false) bool isChargeEnough,

    /// Достаточно ли очков профиля для голосования
    @Default(false) bool isKarmaEnough,

    /// Окончено ли голосование для этого публикации
    @Default(false) bool isVotingOver,
  }) = _PublicationVoteModel;

  factory PublicationVoteModel.fromJson(Map<String, dynamic> json) =>
      _$PublicationVoteModelFromJson(json);

  static const empty = PublicationVoteModel();
}
