part of 'publication.dart';

@freezed
abstract class PublicationVoteResponse with _$PublicationVoteResponse {
  const factory PublicationVoteResponse({
    @Default(PublicationVote.empty) PublicationVote vote,
    @Default(false) bool canVote,
    @Default(0) int score,
    @Default(0) int votesCount,
  }) = _PublicationVoteResponse;

  factory PublicationVoteResponse.fromJson(Map<String, dynamic> json) =>
      _$PublicationVoteResponseFromJson(json);
}
