part of 'part.dart';

abstract interface class TrackerRepository {
  Future<TrackerPublicationsResponse> fetchPublications();
}

@Singleton(as: TrackerRepository)
class TrackerRepositoryImpl implements TrackerRepository {
  TrackerRepositoryImpl(this._service);

  final TrackerService _service;

  @override
  Future<TrackerPublicationsResponse> fetchPublications() async {
    final map = await _service.fetchPublications(
      page: '1',
      byAuthor: false,
    );

    final list = PublicationListResponse.fromMap(map);
    final unread = TrackerUnreadCounters.fromJson(map['unreadCounters']);

    return TrackerPublicationsResponse(
      listResponse: list,
      unreadCounters: unread,
    );
  }
}
