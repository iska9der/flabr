part of 'tracker_notifications_bloc.dart';

@freezed
class TrackerNotificationsEvent with _$TrackerNotificationsEvent {
  const factory TrackerNotificationsEvent.load() = LoadEvent;
}