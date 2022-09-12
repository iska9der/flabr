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
}
