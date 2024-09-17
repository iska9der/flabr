part of 'tracker_publications_remover_bloc.dart';

@freezed
class TrackerPublicationsRemoverState with _$TrackerPublicationsRemoverState {
  const factory TrackerPublicationsRemoverState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default('') String error,
    @Default({}) Set<String> markedIds,
  }) = _TrackerPublicationsRemoverState;
}
