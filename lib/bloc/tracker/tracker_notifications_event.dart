part of 'tracker_notifications_bloc.dart';

@freezed
sealed class TrackerNotificationsEvent with _$TrackerNotificationsEvent {
  const factory TrackerNotificationsEvent.subscribe() = SubscribeEvent;

  const factory TrackerNotificationsEvent.load() = LoadEvent;
}
