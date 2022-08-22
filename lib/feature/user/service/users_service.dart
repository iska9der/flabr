import '../model/user_model.dart';
import '../model/users_response.dart';
import '../repository/users_repository.dart';

class UsersService {
  UsersService(UsersRepository repository) : _repository = repository;

  final UsersRepository _repository;

  UsersResponse cached = UsersResponse.empty;

  Future<UsersResponse> fetchAll({required String page}) async {
    final response = await _repository.fetchAll(page: page);

    cached = cached.copyWith(models: [...cached.models, ...response.models]);

    return response;
  }

  Future<UserModel> fetchByLogin(String login) async {
    final raw = await _repository.fetchByLogin(login);

    UserModel model = UserModel.fromMap(raw);

    return model;
  }

  UserModel getByLogin(String login) {
    return cached.models.firstWhere((element) => element.alias == login);
  }
}
