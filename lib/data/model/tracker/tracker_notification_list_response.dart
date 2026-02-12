part of 'tracker.dart';

class TrackerNotificationListResponse extends ListResponse<TrackerNotification>
    with EquatableMixin {
  const TrackerNotificationListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    super.refs = const [],
  });

  factory TrackerNotificationListResponse.fromMap(Map<String, dynamic> map) {
    final idsMap = List<String>.from(map['itemIds'] ?? []);
    final refsMap = Map<String, dynamic>.from(map['itemRefs'] ?? {});

    return TrackerNotificationListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: UnmodifiableListView(idsMap),
      refs: UnmodifiableListView(
        refsMap.entries.map((e) => TrackerNotification.fromJson(e.value)),
      ),
    );
  }

  static const empty = TrackerNotificationListResponse(pagesCount: 0);

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
