part of 'publication_vote_bloc.dart';

@freezed
abstract class PublicationVoteState with _$PublicationVoteState {
  const factory PublicationVoteState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    PublicationVoteResponse? result,
    String? error,
  }) = _PublicationVoteState;
}
