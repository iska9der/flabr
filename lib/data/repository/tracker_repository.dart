part of 'part.dart';

abstract interface class TrackerRepository {
  Future<TrackerPublicationsResponse> fetchPublications({
    String page,
    bool byAuthor,
  });

  Future<TrackerUnreadCounters> readPublications(List<String> ids);

  Future<void> deletePublications(List<String> ids);

  Future<TrackerNotificationsResponse> fetchNotifications({
    String page,
    required TrackerNotificationCategory category,
  });

  Future<TrackerUnreadCounters> readNotifications(List<String> ids);
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
    list.refs.sort(
      (a, b) => b.unreadCommentsCount.compareTo(a.unreadCommentsCount),
    );

    final unread = TrackerUnreadCounters.fromJson(map['unreadCounters']);
    final response = TrackerPublicationsResponse(
      list: list,
      unreadCounters: unread,
    );

    return response;
  }

  @override
  Future<TrackerUnreadCounters> readPublications(List<String> ids) async {
    final raw = await _service.readPublications(ids);

    final unread = TrackerUnreadCounters.fromJson(raw['unreadCounters']);

    return unread;
  }

  @override
  Future<void> deletePublications(List<String> ids) async {
    await _service.deletePublications(ids);
  }

  @override
  Future<TrackerNotificationsResponse> fetchNotifications({
    String page = '1',
    required TrackerNotificationCategory category,
  }) async {
    final raw = await _service.fetchNotifications(
      page: page,
      category: category.name,
    );

    final list = TrackerNotificationListResponse.fromJson(raw);
    final unread = TrackerUnreadCounters.fromJson(raw['unreadCounters']);
    final response = TrackerNotificationsResponse(
      list: list,
      unreadCounters: unread,
    );

    return response;
  }

  @override
  Future<TrackerUnreadCounters> readNotifications(List<String> ids) async {
    final raw = await _service.readNotifications(ids);

    final unread = TrackerUnreadCounters.fromJson(raw['unreadCounters']);

    return unread;
  }
}
