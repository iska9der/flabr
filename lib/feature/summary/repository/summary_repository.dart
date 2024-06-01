import 'package:injectable/injectable.dart';

import '../../../config/constants.dart';
import '../model/summary_model.dart';
import '../service/summary_service.dart';

@LazySingleton()
class SummaryRepository {
  SummaryRepository(this._service);

  final SummaryService _service;

  final Map<String, SummaryModel> cachedArticles = {};

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
