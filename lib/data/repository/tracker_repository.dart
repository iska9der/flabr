part of 'part.dart';

abstract interface class TrackerRepository {
  Future<TrackerPublicationsResponse> fetchPublications({
    String page,
    bool byAuthor,
  });

  Future<void> deletePublications(List<String> ids);

  /// TODO тип для нотификаций
  Future fetchNotifications();
}

@Singleton(as: TrackerRepository)
class TrackerRepositoryImpl implements TrackerRepository {
  TrackerRepositoryImpl(this._service);

  final TrackerService _service;

  @override
  Future<TrackerPublicationsResponse> fetchPublications({
    String page = '1',
    bool byAuthor = false,
  }) async {
    final map = await _service.fetchPublications(
      page: page,
      byAuthor: byAuthor,
    );

    final list = TrackerPublicationListResponse.fromMap(map);
    final unread = TrackerUnreadCounters.fromJson(map['unreadCounters']);

    return TrackerPublicationsResponse(
      listResponse: list,
      unreadCounters: unread,
    );
  }

  @override
  Future<void> deletePublications(List<String> ids) async {
    await _service.deletePublications(ids);
  }

  @override
  Future fetchNotifications() {
    // TODO: implement fetchNotifications
    throw UnimplementedError();
  }
}
