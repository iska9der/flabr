part of 'publication_vote_bloc.dart';

sealed class PublicationVoteEvent extends Equatable {
  const PublicationVoteEvent({
    required this.id,
    this.vote = PublicationVoteModel.empty,
  });

  final String id;
  final PublicationVoteModel vote;

  @override
  List<Object> get props => [id, vote];
}

class PublicationVoteUpEvent extends PublicationVoteEvent {
  const PublicationVoteUpEvent({
    required super.id,
    super.vote,
  });
}

class PublicationVoteDownEvent extends PublicationVoteEvent {
  const PublicationVoteDownEvent({
    required super.id,
    super.vote,
  });
}
