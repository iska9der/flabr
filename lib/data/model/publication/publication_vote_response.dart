import 'package:freezed_annotation/freezed_annotation.dart';

part 'publication_vote_response.freezed.dart';
part 'publication_vote_response.g.dart';

@freezed
class PublicationVoteResponse with _$PublicationVoteResponse {
  factory PublicationVoteResponse({
    @Default(false) bool canVote,
    @Default(0) int score,
    @Default(0) int votesCount,
  }) = _PublicationVoteResponse;

  factory PublicationVoteResponse.fromJson(Map<String, dynamic> json) =>
      _$PublicationVoteResponseFromJson(json);
}
