part of 'tracker_notifications_bloc.dart';

@freezed
sealed class TrackerNotificationsEvent with _$TrackerNotificationsEvent {
  const factory TrackerNotificationsEvent.subscribe() = _SubscribeEvent;

  const factory TrackerNotificationsEvent.load() = _LoadEvent;

  const factory TrackerNotificationsEvent.loaded(
    ListResponse<TrackerNotification> response,
  ) = _LoadedEvent;
}
