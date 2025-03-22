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
    TrackerPublicationListResponse list,
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
    var idsMap = map['publicationIds'];
    Map refsMap = map['publicationRefs'];

    return TrackerPublicationListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: List<String>.from(idsMap),
      refs:
          Map.from(
            refsMap,
          ).entries.map((e) => TrackerPublication.fromJson(e.value)).toList(),
    );
  }

  static const empty = TrackerPublicationListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
