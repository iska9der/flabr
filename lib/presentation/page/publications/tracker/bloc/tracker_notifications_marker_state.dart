part of 'tracker_notifications_marker_bloc.dart';

@freezed
class TrackerNotificationsMarkerState with _$TrackerNotificationsMarkerState {
  const TrackerNotificationsMarkerState._();

  const factory TrackerNotificationsMarkerState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default('') String error,
    required TrackerNotificationCategory category,
  }) = _TrackerNotificationsMarkerState;
}
