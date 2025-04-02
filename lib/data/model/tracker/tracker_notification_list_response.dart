import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../list_response_model.dart';
import 'tracker_notification_model.dart';
import 'tracker_unread_counters_model.dart';

part 'tracker_notification_list_response.freezed.dart';

@freezed
class TrackerNotificationsResponse with _$TrackerNotificationsResponse {
  const factory TrackerNotificationsResponse({
    @Default(TrackerNotificationListResponse.empty)
    ListResponse<TrackerNotification> list,
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
