part of 'tracker_notifications_bloc.dart';

@freezed
class TrackerNotificationsState with _$TrackerNotificationsState {
  const TrackerNotificationsState._();

  const factory TrackerNotificationsState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default('') String error,
    required TrackerNotificationCategory category,
    @Default(TrackerNotificationListResponse.empty)
    ListResponse<TrackerNotification> response,
    @Default(1) int page,
  }) = _TrackerNotificationsState;

  bool get isFirstFetch => page == 1;
  bool get isLastPage => page >= response.pagesCount;
}
