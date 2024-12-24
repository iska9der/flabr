part of 'part.dart';

abstract interface class TrackerService {
  /// Получить список отслеживаемых публикаций
  Future<Map<String, dynamic>> fetchPublications({
    required String page,
    required bool byAuthor,
  });

  /// Удалить публикации из отслеживаемых
  Future<void> deletePublications(List<String> ids);

  /// Получить список уведомлений
  Future<Map<String, dynamic>> fetchNotifications({
    required String page,
    required String category,
  });

  /// Отметить уведомления прочитанными
  Future<Map<String, dynamic>> readNotifications({
    List<String> ids = const [],
  });
}

@LazySingleton(as: TrackerService)
class TrackerServiceImpl implements TrackerService {
  const TrackerServiceImpl({
    @Named('siteClient') required HttpClient siteClient,
  }) : _siteClient = siteClient;

  final HttpClient _siteClient;

  @override
  Future<Map<String, dynamic>> fetchPublications({
    required String page,
    required bool byAuthor,
  }) async {
    try {
      final params = TrackerPublicationParams(
        page: page,
        byAuthor: byAuthor,
      );

      final response = await _siteClient.get(
        '/v2/tracker/publications',
        queryParams: params.toMap(),
      );

      return response.data;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

  @override
  Future<void> deletePublications(List<String> ids) async {
    try {
      final response = await _siteClient.delete(
        '/v2/tracker/publications',
        body: {'ids': ids},
      );

      return response.data;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

  @override
  Future<Map<String, dynamic>> fetchNotifications({
    required String page,
    required String category,
  }) async {
    try {
      final params = TrackerNotificationParams(
        page: page,
        category: category,
      );

      final response = await _siteClient.get(
        '/v2/me/notifications',
        queryParams: params.toMap(),
      );

      return response.data;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

  @override
  Future<Map<String, dynamic>> readNotifications({
    List<String> ids = const [],
  }) async {
    try {
      final response = await _siteClient.post(
        '/v2/me/notifications/read',
        body: {'ids': ids},
      );

      return response.data;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }
}
