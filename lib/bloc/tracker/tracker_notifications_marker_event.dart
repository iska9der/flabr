part of 'tracker_notifications_marker_bloc.dart';

@freezed
sealed class TrackerNotificationsMarkerEvent
    with _$TrackerNotificationsMarkerEvent {
  const factory TrackerNotificationsMarkerEvent.read({
    required List<String> ids,

    /// Например когда отметка происходит заодно с открытием экрана,
    /// то не нужно показывать ошибку, если что-то пойдет не так
    @Default(true) bool isErrorEnabled,
  }) = MarkAsReadEvent;
}
