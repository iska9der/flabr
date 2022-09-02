import '../../../component/language.dart';
import '../model/network/user_list_response.dart';
import '../model/user_model.dart';
import '../model/user_whois_model.dart';
import '../repository/user_repository.dart';

class UserService {
  UserService(UserRepository repository) : _repository = repository;

  final UserRepository _repository;

  UserListResponse cached = UserListResponse.empty;

  Future<UserListResponse> fetchAll({
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
    required String page,
  }) async {
    final response = await _repository.fetchAll(
      langUI: langUI.name,
      langArticles: encodeLangs(langArticles),
      page: page,
    );

    cached = cached.copyWith(refs: [...cached.refs, ...response.refs]);

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
    return cached.refs.firstWhere((element) => element.alias == login);
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
