import '../../../common/exception/displayable_exception.dart';
import '../../../common/exception/fetch_exception.dart';
import '../../../common/model/network/params.dart';
import '../../../component/http/http_client.dart';
import '../model/network/user_comment_list_response.dart';
import '../model/network/user_list_response.dart';

class UserService {
  const UserService({
    required HttpClient mobileClient,
    required HttpClient siteClient,
  })  : _mobileClient = mobileClient,
        _siteClient = siteClient;

  final HttpClient _mobileClient;
  final HttpClient _siteClient;

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
