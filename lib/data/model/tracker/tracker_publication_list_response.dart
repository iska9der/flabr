import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../list_response_model.dart';
import 'tracker_publication_model.dart';
import 'tracker_unread_counters_model.dart';

part 'tracker_publication_list_response.freezed.dart';

@freezed
class TrackerPublicationsResponse with _$TrackerPublicationsResponse {
  const factory TrackerPublicationsResponse({
    @Default(TrackerPublicationListResponse.empty)
    ListResponse<TrackerPublication> list,
    @Default(TrackerUnreadCounters()) TrackerUnreadCounters unreadCounters,
  }) = _TrackerPublicationsResponse;
}

class TrackerPublicationListResponse extends ListResponse<TrackerPublication>
    with EquatableMixin {
  const TrackerPublicationListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    super.refs = const [],
  });

  factory TrackerPublicationListResponse.fromMap(Map<String, dynamic> map) {
    final idsMap = List<String>.from(map['publicationIds'] ?? []);
    final refsMap = Map<String, dynamic>.from(map['publicationRefs'] ?? {});

    return TrackerPublicationListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: UnmodifiableListView(idsMap),
      refs: UnmodifiableListView(
        refsMap.entries.map((e) => TrackerPublication.fromJson(e.value)),
      ),
    );
  }

  static const empty = TrackerPublicationListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
