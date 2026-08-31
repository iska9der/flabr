import 'package:injectable/injectable.dart';
import 'package:ya_summary/ya_summary.dart';

abstract interface class SummaryRepository {
  Future<SummaryModel> fetchSummary(String url);
}

@Singleton(as: SummaryRepository)
class SummaryRepositoryImpl implements SummaryRepository {
  SummaryRepositoryImpl(this._api);

  final SummaryApi _api;
  final Map<String, SummaryModel> _cache = {};

  @override
  Future<SummaryModel> fetchSummary(String url) async {
    final cached = _cache[url];
    if (cached != null) {
      return cached;
    }

    final model = await _api.fetchSummary(url);
    _cache[url] = model;

    return model;
  }
}
