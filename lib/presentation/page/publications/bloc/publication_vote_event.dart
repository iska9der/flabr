part of 'publication_vote_bloc.dart';

@freezed
class PublicationVoteEvent with _$PublicationVoteEvent {
  const factory PublicationVoteEvent.voteUp() = _VoteUpEvent;
  const factory PublicationVoteEvent.voteDown() = _VoteDownEvent;
}
