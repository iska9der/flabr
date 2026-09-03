import 'package:injectable/injectable.dart';

import '../../core/component/http/http.dart';
import '../exception/exception.dart';
import '../model/list_response_model.dart';
import '../model/query_params_model.dart';
import '../model/user/user.dart';

abstract interface class UserService {
  Future<UserListResponse> fetchAll({required String page});

  Future<User> fetchCard({required String alias});

  Future<UserWhois> fetchWhois({required String alias});

  Future<void> toggleSubscription({required String alias});

  Future<UserCommentListResponse> fetchCommentsInBookmarks({
    required String alias,
    required int page,
  });

  Future<ListResponse<UserComment>> fetchComments({
    required String alias,
    required int page,
  });
}

@LazySingleton(as: UserService)
class UserServiceImpl implements UserService {
  const UserServiceImpl({
    @Named('siteClient') required this._siteClient,
  });

  final HttpClient _siteClient;

  @override
  Future<UserListResponse> fetchAll({required String page}) async {
    final params = QueryParams(page: page).toMap();
    final response = await _siteClient.get('/v2/users', queryParams: params);

    return UserListResponse.fromMap(response.data);
  }

  @override
  Future<User> fetchCard({required String alias}) async {
    final response = await _siteClient.get('/v2/users/$alias/card');

    return User.fromMap(response.data);
  }

  @override
  Future<UserWhois> fetchWhois({required String alias}) async {
    final response = await _siteClient.get('/v2/users/$alias/whois');

    return UserWhois.fromMap(response.data);
  }

  @override
  Future<void> toggleSubscription({required String alias}) async {
    await _siteClient.post('/v2/users/$alias/following/toggle', body: {});
  }

  @override
  Future<UserCommentListResponse> fetchCommentsInBookmarks({
    required String alias,
    required int page,
  }) async {
    try {
      final response = await _siteClient.get(
        '/v2/users/$alias/bookmarks/comments?page=$page',
      );

      return UserCommentListResponse.fromMap(response.data);
    } on FetchException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        error.withType(.bookmarkCommentsLoadFailed),
        stackTrace,
      );
    }
  }

  @override
  Future<ListResponse<UserComment>> fetchComments({
    required String alias,
    required int page,
  }) async {
    try {
      final response = await _siteClient.get(
        '/v2/users/$alias/comments?page=$page',
      );

      return UserCommentListResponse.fromMap(response.data);
    } on FetchException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        error.withType(.userCommentsLoadFailed),
        stackTrace,
      );
    }
  }
}
