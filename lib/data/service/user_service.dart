import 'package:injectable/injectable.dart';

import '../../core/component/http/http.dart';
import '../exception/exception.dart';
import '../model/list_response_model.dart';
import '../model/query_params_model.dart';
import '../model/user/user.dart';

abstract interface class UserService {
  Future<UserListResponse> fetchAll({required String page});

  Future<Map<String, dynamic>> fetchCard({required String alias});

  Future<Map<String, dynamic>> fetchWhois({required String alias});

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
    @Named('mobileClient') required HttpClient mobileClient,
    @Named('siteClient') required HttpClient siteClient,
  }) : _mobileClient = mobileClient,
       _siteClient = siteClient;

  final HttpClient _mobileClient;
  final HttpClient _siteClient;

  @override
  Future<UserListResponse> fetchAll({required String page}) async {
    try {
      final params = QueryParams(page: page).toMap();

      final response = await _mobileClient.get('/users', queryParams: params);

      return UserListResponse.fromMap(response.data);
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchCard({required String alias}) async {
    try {
      final response = await _mobileClient.get('/users/$alias/card');

      return response.data;
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchWhois({required String alias}) async {
    try {
      final response = await _mobileClient.get('/users/$alias/whois');

      return response.data;
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<void> toggleSubscription({required String alias}) async {
    try {
      await _siteClient.post('/v2/users/$alias/following/toggle', body: {});
    } on AppException {
      rethrow;
    } catch (_, stackTrace) {
      Error.throwWithStackTrace(const FetchException(), stackTrace);
    }
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
    } on AppException {
      rethrow;
    } catch (_, trace) {
      Error.throwWithStackTrace(
        const FetchException('Не удалось получить комментарии в закладках'),
        trace,
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
    } on AppException {
      rethrow;
    } catch (_, trace) {
      Error.throwWithStackTrace(
        const FetchException('Не удалось получить комментарии пользователя'),
        trace,
      );
    }
  }
}
