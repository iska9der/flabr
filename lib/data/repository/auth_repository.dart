part of 'part.dart';

@Singleton()
class AuthRepository {
  AuthRepository(AuthService service) : _service = service;

  final AuthService _service;

  Future<UserMe?> fetchMe() async {
    final raw = await _service.fetchMe();

    if (raw == null) {
      return null;
    }

    return UserMe.fromMap(raw);
  }

  fetchCsrf(Tokens tokens) async {
    String rawHtml = await _service.fetchRawMainPage(tokens.toCookieString());

    String csrf = '';
    int indexOfCsrfStart = rawHtml.indexOf('csrf-token') + 11;
    int indexOfFirstQuote = rawHtml.indexOf('"', indexOfCsrfStart) + 1;
    int indexOfLastQuote = rawHtml.indexOf('"', indexOfFirstQuote);
    csrf = rawHtml.substring(indexOfFirstQuote, indexOfLastQuote);

    return csrf;
  }
}
