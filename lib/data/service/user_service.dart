part of 'service_part.dart';

abstract interface class UserService {
  Future<UserListResponse> fetchAll({
    required String langUI,
    required String langArticles,
    required String page,
  });

  Future<Map<String, dynamic>> fetchCard({
    required String alias,
    required String langUI,
    required String langArticles,
  });

  Future<Map<String, dynamic>> fetchWhois({
    required String alias,
    required String langUI,
    required String langArticles,
  });

  Future<void> toggleSubscription({required String alias});

  Future<UserCommentListResponse> fetchCommentsInBookmarks({
    required String alias,
    required int page,
  });

  Future<UserCommentListResponse> fetchComments({
    required String alias,
    required int page,
  });
}

@LazySingleton(as: UserService)
class UserServiceImpl implements UserService {
  const UserServiceImpl({
    @Named('mobileClient') required HttpClient mobileClient,
    @Named('siteClient') required HttpClient siteClient,
  })  : _mobileClient = mobileClient,
        _siteClient = siteClient;

  final HttpClient _mobileClient;
  final HttpClient _siteClient;

  @override
  Future<UserListResponse> fetchAll({
    required String langUI,
    required String langArticles,
    required String page,
  }) async {
    try {
      final params = Params(
        langArticles: langArticles,
        langUI: langUI,
        page: page,
      );

      final response = await _mobileClient.get(
        '/users?${params.toQueryString()}',
      );

      return UserListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchCard({
    required String alias,
    required String langUI,
    required String langArticles,
  }) async {
    try {
      final params = Params(langArticles: langArticles, langUI: langUI);

      final response = await _mobileClient.get(
        '/users/$alias/card?${params.toQueryString()}',
      );

      return response.data;
    } on DisplayableException {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchWhois({
    required String alias,
    required String langUI,
    required String langArticles,
  }) async {
    try {
      final params = Params(langArticles: langArticles, langUI: langUI);

      final response = await _mobileClient.get(
        '/users/$alias/whois?${params.toQueryString()}',
      );

      return response.data;
    } on DisplayableException {
      rethrow;
    }
  }

  @override
  Future<void> toggleSubscription({required String alias}) async {
    try {
      await _siteClient.post(
        '/v2/users/$alias/following/toggle',
        body: {},
      );
    } on DisplayableException {
      rethrow;
    } catch (e) {
      throw FetchException();
    }
  }

  @override
  Future<UserCommentListResponse> fetchCommentsInBookmarks({
    required String alias,
    required int page,
  }) async {
    try {
      final response = await _siteClient.get(
        '/v2/users/$alias/bookmarks/comments?fl=ru&hl=ru&page=$page',
      );

      return UserCommentListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    } catch (e, trace) {
      Error.throwWithStackTrace(
        FetchException('Не удалось получить комментарии в закладках'),
        trace,
      );
    }
  }

  @override
  Future<UserCommentListResponse> fetchComments({
    required String alias,
    required int page,
  }) async {
    try {
      final response = await _siteClient.get(
        '/v2/users/$alias/comments?fl=ru&hl=ru&page=$page',
      );

      return UserCommentListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    } catch (e, trace) {
      Error.throwWithStackTrace(
        FetchException('Не удалось получить комментарии пользователя'),
        trace,
      );
    }
  }
}
