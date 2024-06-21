part of 'tracker_publications_bloc.dart';

@freezed
class TrackerPublicationsState with _$TrackerPublicationsState {
  const factory TrackerPublicationsState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default('') String error,
    @Default(TrackerPublicationsResponse())
    TrackerPublicationsResponse response,
  }) = _TrackerPublicationsState;
}
