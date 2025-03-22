import 'summary_model.dart';
import 'summary_service.dart';

abstract interface class SummaryRepository {
  Future<SummaryModel> fetchSummary(String url);
}

class SummaryRepositoryImpl implements SummaryRepository {
  SummaryRepositoryImpl({
    required this.service,
  });

  final SummaryService service;

  @override
  Future<SummaryModel> fetchSummary(String url) async {
    final sharingUrl = await service.fetchSharingUrl(url);
    final token = sharingUrl.split('/').last;
    final map = await service.fetchSharedData(token);
    final model = SummaryModel.fromMap(map);

    return model;
  }
}

abstract interface class SummaryTokenRepository {
  Future<String?> getToken();

  Future<void> setToken(String token);

  Future<void> clear();
}

class SummaryTokenRepositoryImpl implements SummaryTokenRepository {
  SummaryTokenRepositoryImpl();

  String _token = '';

  @override
  Future<String?> getToken() async {
    return _token;
  }

  @override
  Future<void> setToken(String token) async {
    _token = token;
  }

  @override
  Future<void> clear() async {
    _token = '';
  }
}
