part of 'tracker.dart';

@freezed
class TrackerPublicationsResponse with _$TrackerPublicationsResponse {
  const factory TrackerPublicationsResponse({
    @Default(TrackerPublicationListResponse.empty)
    TrackerPublicationListResponse list,
    @Default(TrackerUnreadCounters()) TrackerUnreadCounters unreadCounters,
  }) = _TrackerPublicationsResponse;
}

class TrackerPublicationListResponse extends ListResponse with EquatableMixin {
  const TrackerPublicationListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    List<TrackerPublication> super.refs = const [],
  });

  @override
  List<TrackerPublication> get refs => super.refs as List<TrackerPublication>;

  @override
  TrackerPublicationListResponse copyWith({
    int? pagesCount,
    List<String>? ids,
    List<dynamic>? refs,
  }) {
    return TrackerPublicationListResponse(
      pagesCount: pagesCount ?? this.pagesCount,
      ids: ids ?? this.ids,
      refs: List<TrackerPublication>.from((refs ?? this.refs)),
    );
  }

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
