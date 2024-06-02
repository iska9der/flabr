import 'package:injectable/injectable.dart';

import '../../../config/constants.dart';
import 'summary_model.dart';
import 'summary_service.dart';

abstract interface class SummaryRepository {
  SummaryRepository();

  Future<SummaryModel> fetchArticleSummary(String articleId);
}

@LazySingleton(as: SummaryRepository)
class SummaryRepositoryImpl implements SummaryRepository {
  SummaryRepositoryImpl(this._service);

  final SummaryService _service;

  final Map<String, SummaryModel> cachedArticles = {};

  @override
  Future<SummaryModel> fetchArticleSummary(String articleId) async {
    if (cachedArticles.containsKey(articleId)) {
      return cachedArticles[articleId]!;
    }

    final articleUrl = '$baseUrl/ru/articles/$articleId';
    final sharingUrl = await _service.fetchSharingUrl(articleUrl);
    final token = sharingUrl.split('/').last;
    final map = await _service.fetchSharedData(token);
    final model = SummaryModel.fromMap(map);
    cachedArticles[articleId] = model;

    return model;
  }
}
