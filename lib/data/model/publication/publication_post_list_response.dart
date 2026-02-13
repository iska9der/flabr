part of 'publication.dart';

class PublicationPostListResponse extends ListResponse<Publication>
    with EquatableMixin {
  const PublicationPostListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    super.refs = const [],
  });

  factory PublicationPostListResponse.fromMap(Map<String, dynamic> map) {
    final idsMap = List<String>.from(map['publicationIds'] ?? []);
    final refsMap = Map<String, dynamic>.from(map['publicationRefs'] ?? {});

    return PublicationPostListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: UnmodifiableListView(idsMap),
      refs: UnmodifiableListView(
        refsMap.entries.map((e) => PublicationPost.fromJson(e.value)),
      ),
    );
  }

  static const empty = PublicationPostListResponse(pagesCount: 0);
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
