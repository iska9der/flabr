part of 'tracker_notifications_marker_bloc.dart';

@freezed
abstract class TrackerNotificationsMarkerState
    with _$TrackerNotificationsMarkerState {
  const TrackerNotificationsMarkerState._();

  const factory TrackerNotificationsMarkerState({
    required TrackerNotificationCategory category,
    @Default(LoadingStatus.initial) LoadingStatus status,

    /// Список идентификаторов, которые сейчас обрабатываются.
    /// Например, когда пользователь отмечает уведомления как прочитанные,
    /// загоняем сюда список идентификаторов этих уведомлений,
    /// чтобы в ui отобразить только у них индикатор загрузки,
    /// а не у всех уведомлений
    @Default([]) List<String> handledIds,
    @Default('') String error,
  }) = _TrackerNotificationsMarkerState;
}
