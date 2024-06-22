part of 'tracker_notifications_bloc.dart';

@freezed
class TrackerNotificationsState with _$TrackerNotificationsState {
  const factory TrackerNotificationsState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default('') String error,
    required TrackerNotificationCategory category,
    @Default(TrackerNotificationListResponse())
    TrackerNotificationListResponse response,
  }) = _TrackerNotificationsState;
}
