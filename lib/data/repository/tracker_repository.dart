import 'dart:async';

import 'package:injectable/injectable.dart';

import '../model/list_response_model.dart';
import '../model/tracker/tracker.dart';
import '../service/service.dart';

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
    final unread = TrackerUnreadCounters.fromJson(map['unreadCounters']);

    ListResponse<TrackerPublication> listResponse =
        TrackerPublicationListResponse.fromMap(map);

    /// сортируем по количеству непрочитанных комментариев
    final sortedRefs = [...listResponse.refs]
      ..sort((a, b) => b.unreadCommentsCount.compareTo(a.unreadCommentsCount));
    listResponse = listResponse.copyWith(refs: sortedRefs);

    final response = TrackerPublicationsResponse(
      list: listResponse,
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
    final unread = TrackerUnreadCounters.fromJson(raw['unreadCounters']);

    final listResponse = TrackerNotificationListResponse.fromMap(raw);

    final response = TrackerNotificationsResponse(
      list: listResponse,
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
