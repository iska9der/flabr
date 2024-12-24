part of 'part.dart';

abstract interface class SummaryRepository {
  Future<SummaryModel> fetchArticleSummary(String articleId);
}

@Singleton(as: SummaryRepository)
class SummaryRepositoryImpl implements SummaryRepository {
  SummaryRepositoryImpl(this._service);

  final SummaryService _service;

  final Map<String, SummaryModel> cachedArticles = {};

  @override
  Future<SummaryModel> fetchArticleSummary(String articleId) async {
    if (cachedArticles.containsKey(articleId)) {
      return cachedArticles[articleId]!;
    }

    final articleUrl = '${Urls.baseUrl}/ru/articles/$articleId';
    final sharingUrl = await _service.fetchSharingUrl(articleUrl);
    final token = sharingUrl.split('/').last;
    final map = await _service.fetchSharedData(token);
    final model = SummaryModel.fromMap(map);
    cachedArticles[articleId] = model;

    return model;
  }
}
