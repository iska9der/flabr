part of 'part.dart';

abstract interface class TrackerService {
  Future<Map<String, dynamic>> fetchPublications({
    required String page,
    required bool byAuthor,
  });

  Future<void> deletePublications(List<String> ids);
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
}
