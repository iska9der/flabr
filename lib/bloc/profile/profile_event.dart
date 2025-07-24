part of 'profile_bloc.dart';

@freezed
sealed class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.reset() = _ResetEvent;
  const factory ProfileEvent.fetchMe() = _FetchMeEvent;
  const factory ProfileEvent.fetchUpdates() = _FetchUpdatesEvent;
}
