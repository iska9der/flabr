import '../model/auth_data_model.dart';
import '../model/me_model.dart';
import '../repository/auth_repository.dart';

class AuthService {
  AuthService(AuthRepository repository) : _repository = repository;

  final AuthRepository _repository;

  Future<AuthDataModel> login({
    required String login,
    required String password,
  }) async {
    final raw = await _repository.login(login: login, password: password);

    return AuthDataModel.fromMap(raw);
  }

  Future<MeModel> fetchMe(String connectSid) async {
    final raw = await _repository.fetchMe(connectSid);

    return MeModel.fromMap(raw);
  }

  fetchCsrf(AuthDataModel data) async {
    String rawHtml = await _repository.fetchRawMainPage(data);

    String csrf = '';
    int indexOfCsrfStart = rawHtml.indexOf('csrf-token') + 11;
    int indexOfFirstQuote = rawHtml.indexOf('"', indexOfCsrfStart) + 1;
    int indexOfLastQuote = rawHtml.indexOf('"', indexOfFirstQuote);

    csrf = rawHtml.substring(indexOfFirstQuote, indexOfLastQuote);

    return csrf;
  }
}
