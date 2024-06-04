part of 'part.dart';

@LazySingleton()
class UserRepository {
  UserRepository(UserService service) : _service = service;

  final UserService _service;

  UserListResponse cached = UserListResponse.empty;

  Future<UserListResponse> fetchAll({
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
    required String page,
  }) async {
    final response = await _service.fetchAll(
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
      page: page,
    );

    cached = cached.copyWith(refs: [...cached.refs, ...response.refs]);

    return response;
  }

  Future<UserModel> fetchCard({
    required String login,
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  }) async {
    final raw = await _service.fetchCard(
      alias: login,
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
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
    final raw = await _service.fetchWhois(
      alias: login,
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
    );

    UserWhoisModel model = UserWhoisModel.fromMap(raw);

    return model;
  }

  Future<UserCommentListResponse> fetchComments({
    required String alias,
    required int page,
  }) async {
    final response = await _service.fetchComments(
      alias: alias,
      page: page,
    );

    response.refs.sort(
      (a, b) => b.timePublished.compareTo(a.timePublished),
    );

    return response;
  }

  Future<UserCommentListResponse> fetchCommentsInBookmarks({
    required String alias,
    int page = 1,
  }) =>
      _service.fetchCommentsInBookmarks(
        alias: alias,
        page: page,
      );
}
