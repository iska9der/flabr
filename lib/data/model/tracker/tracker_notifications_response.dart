part of 'tracker.dart';

@freezed
class TrackerNotificationsResponse with _$TrackerNotificationsResponse {
  const factory TrackerNotificationsResponse({
    @Default(TrackerNotificationListResponse.empty)
    TrackerNotificationListResponse list,
    @Default(TrackerUnreadCounters()) TrackerUnreadCounters unreadCounters,
  }) = _TrackerNotificationsResponse;
}

class TrackerNotificationListResponse extends ListResponse<TrackerNotification>
    with EquatableMixin {
  const TrackerNotificationListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    super.refs = const [],
  });

  factory TrackerNotificationListResponse.fromMap(Map<String, dynamic> map) {
    var idsMap = map['itemIds'];
    Map refsMap = map['itemRefs'];

    return TrackerNotificationListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: List<String>.from(idsMap),
      refs:
          Map.from(
            refsMap,
          ).entries.map((e) => TrackerNotification.fromJson(e.value)).toList(),
    );
  }

  static const empty = TrackerNotificationListResponse(pagesCount: 0);

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
