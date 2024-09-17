part of 'part.dart';

@freezed
class TrackerNotificationsResponse with _$TrackerNotificationsResponse {
  const factory TrackerNotificationsResponse({
    @Default(TrackerNotificationListResponse.empty)
    TrackerNotificationListResponse list,
    @Default(TrackerUnreadCounters()) TrackerUnreadCounters unreadCounters,
  }) = _TrackerNotificationsResponse;
}

class TrackerNotificationListResponse extends ListResponse with EquatableMixin {
  const TrackerNotificationListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    List<TrackerNotification> super.refs = const [],
  });

  @override
  List<TrackerNotification> get refs => super.refs as List<TrackerNotification>;

  @override
  TrackerNotificationListResponse copyWith({
    int? pagesCount,
    List<String>? ids,
    List<dynamic>? refs,
  }) {
    return TrackerNotificationListResponse(
      pagesCount: pagesCount ?? this.pagesCount,
      ids: ids ?? this.ids,
      refs: List<TrackerNotification>.from((refs ?? this.refs)),
    );
  }

  factory TrackerNotificationListResponse.fromJson(Map<String, dynamic> map) {
    var idsMap = map['itemIds'];
    Map refsMap = map['itemRefs'];

    return TrackerNotificationListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: List<String>.from(idsMap),
      refs: Map.from(refsMap)
          .entries
          .map((e) => TrackerNotification.fromJson(e.value))
          .toList(),
    );
  }

  static const empty = TrackerNotificationListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
