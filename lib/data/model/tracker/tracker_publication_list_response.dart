import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../list_response_model.dart';
import 'tracker_publication_model.dart';

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
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
