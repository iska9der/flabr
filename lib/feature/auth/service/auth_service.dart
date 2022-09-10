import '../model/auth_data_model.dart';
import '../repository/auth_repository.dart';

class AuthService {
  AuthService(AuthRepository repository) : _repository = repository;

  final AuthRepository _repository;

  AuthDataModel _authData = AuthDataModel.empty;
  AuthDataModel get authData => _authData;

  Future<void> login({
    required String login,
    required String password,
  }) async {
    final raw = await _repository.login(login: login, password: password);

    _authData = AuthDataModel.fromMap(raw);
  }

  void clearCachedAuth() {
    _authData = AuthDataModel.empty;
  }
}
