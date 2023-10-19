import '../model/auth_data_model.dart';
import '../model/me_model.dart';
import '../service/auth_service.dart';

class AuthRepository {
  AuthRepository(AuthService service) : _service = service;

  final AuthService _service;

  Future<MeModel?> fetchMe(String connectSid) async {
    final raw = await _service.fetchMe(connectSid);

    if (raw == null) {
      return null;
    }

    return MeModel.fromMap(raw);
  }

  fetchCsrf(AuthDataModel data) async {
    String rawHtml = await _service.fetchRawMainPage(data);

    String csrf = '';
    int indexOfCsrfStart = rawHtml.indexOf('csrf-token') + 11;
    int indexOfFirstQuote = rawHtml.indexOf('"', indexOfCsrfStart) + 1;
    int indexOfLastQuote = rawHtml.indexOf('"', indexOfFirstQuote);
    csrf = rawHtml.substring(indexOfFirstQuote, indexOfLastQuote);

    return csrf;
  }
}
