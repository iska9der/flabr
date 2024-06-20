part of 'tracker_bloc.dart';

@freezed
class TrackerState with _$TrackerState {
  const factory TrackerState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default(TrackerPublicationsResponse())
    TrackerPublicationsResponse response,
  }) = _TrackerState;
}
