import '../../../component/language.dart';
import '../model/user_model.dart';
import '../model/user_whois_model.dart';
import '../model/users_response.dart';
import '../repository/users_repository.dart';

class UsersService {
  UsersService(UsersRepository repository) : _repository = repository;

  final UsersRepository _repository;

  UsersResponse cached = UsersResponse.empty;

  Future<UsersResponse> fetchAll({
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
    required String page,
  }) async {
    final response = await _repository.fetchAll(
      langUI: langUI.name,
      langArticles: encodeLangs(langArticles),
      page: page,
    );

    cached = cached.copyWith(models: [...cached.models, ...response.models]);

    return response;
  }

  Future<UserModel> fetchByLogin({
    required String login,
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  }) async {
    final raw = await _repository.fetchByLogin(
      login: login,
      langUI: langUI.name,
      langArticles: encodeLangs(langArticles),
    );

    UserModel model = UserModel.fromMap(raw);

    return model;
  }

  UserModel getByLogin(String login) {
    return cached.models.firstWhere((element) => element.alias == login);
  }

  Future<UserWhoisModel> fetchWhois({
    required String login,
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  }) async {
    final raw = await _repository.fetchWhois(
      login: login,
      langUI: langUI.name,
      langArticles: encodeLangs(langArticles),
    );

    UserWhoisModel model = UserWhoisModel.fromMap(raw);

    return model;
  }
}
