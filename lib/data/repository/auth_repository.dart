part of 'part.dart';

@Singleton()
class AuthRepository {
  AuthRepository(AuthService service) : _service = service;

  final AuthService _service;

  Future<UserMeModel?> fetchMe() async {
    final raw = await _service.fetchMe();

    if (raw == null) {
      return null;
    }

    return UserMeModel.fromMap(raw);
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