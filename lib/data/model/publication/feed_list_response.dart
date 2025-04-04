import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../list_response_model.dart';
import 'publication_model.dart';

class FeedListResponse extends ListResponse<Publication> with EquatableMixin {
  const FeedListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    super.refs = const [],
  });

  factory FeedListResponse.fromMap(Map<String, dynamic> map) {
    final idsMap = List<String>.from(map['publicationIds'] ?? []);
    final refsMap = Map<String, dynamic>.from(map['publicationRefs'] ?? {});

    return FeedListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: UnmodifiableListView(idsMap),
      refs: UnmodifiableListView(
        refsMap.entries.map((e) => Publication.fromMap(e.value)),
      ),
    );
  }

  static const empty = FeedListResponse(pagesCount: 0);
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
