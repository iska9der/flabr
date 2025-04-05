part of 'tracker_notifications_marker_bloc.dart';

@freezed
class TrackerNotificationsMarkerEvent with _$TrackerNotificationsMarkerEvent {
  const factory TrackerNotificationsMarkerEvent.read({
    required List<String> ids,
  }) = MarkAsReadEvent;
}
