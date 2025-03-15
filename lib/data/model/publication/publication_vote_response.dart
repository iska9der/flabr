import 'package:freezed_annotation/freezed_annotation.dart';

import '../related_data/publication_vote_model.dart';

part 'publication_vote_response.freezed.dart';
part 'publication_vote_response.g.dart';

@freezed
class PublicationVoteResponse with _$PublicationVoteResponse {
  factory PublicationVoteResponse({
    @Default(PublicationVote.empty) PublicationVote vote,
    @Default(false) bool canVote,
    @Default(0) int score,
    @Default(0) int votesCount,
  }) = _PublicationVoteResponse;

  factory PublicationVoteResponse.fromJson(Map<String, dynamic> json) =>
      _$PublicationVoteResponseFromJson(json);
}
