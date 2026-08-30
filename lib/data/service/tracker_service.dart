import 'package:injectable/injectable.dart';

import '../../core/component/http/http.dart';
import '../exception/exception.dart';
import '../model/tracker/tracker.dart';

abstract interface class TrackerService {
  /// Получить список отслеживаемых публикаций
  Future<TrackerPublicationListResponse> fetchPublications({
    required String page,
    required bool byAuthor,
  });

  /// Отметить публикации прочитанными
  Future<void> readPublications(List<String> ids);

  /// Удалить публикации из отслеживаемых
  Future<void> deletePublications(List<String> ids);

  /// Получить список уведомлений
  Future<TrackerNotificationListResponse> fetchNotifications({
    required String page,
    required String category,
  });

  /// Отметить уведомления прочитанными
  Future<void> readNotifications(List<String> ids);
}

@LazySingleton(as: TrackerService)
class TrackerServiceImpl implements TrackerService {
  const TrackerServiceImpl({
    @Named('siteClient') required HttpClient siteClient,
  }) : _siteClient = siteClient;

  final HttpClient _siteClient;

  @override
  Future<TrackerPublicationListResponse> fetchPublications({
    required String page,
    required bool byAuthor,
  }) async {
    try {
      final params = TrackerPublicationListParams(
        page: page,
        byAuthor: byAuthor,
      );

      final response = await _siteClient.get(
        '/v2/tracker/publications',
        queryParams: params.toMap(),
      );

      return TrackerPublicationListResponse.fromMap(response.data);
    } catch (e, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }

  @override
  Future<void> readPublications(List<String> ids) async {
    try {
      await _siteClient.post(
        '/v2/tracker/publications/read',
        body: {'ids': ids},
      );
    } catch (e, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }

  @override
  Future<void> deletePublications(List<String> ids) async {
    try {
      await _siteClient.delete(
        '/v2/tracker/publications',
        body: {'ids': ids},
      );
    } catch (e, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }

  @override
  Future<TrackerNotificationListResponse> fetchNotifications({
    required String page,
    required String category,
  }) async {
    try {
      final params = TrackerNotificationListParams(
        page: page,
        category: category,
      );

      final response = await _siteClient.get(
        '/v2/me/notifications',
        queryParams: params.toMap(),
      );

      return TrackerNotificationListResponse.fromMap(response.data);
    } catch (e, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }

  @override
  Future<void> readNotifications(List<String> ids) async {
    try {
      await _siteClient.post(
        '/v2/me/notifications/read',
        body: {'ids': ids},
      );
    } catch (e, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }
}
