import '../../../common/exception/displayable_exception.dart';
import '../../../common/exception/fetch_exception.dart';
import '../../../common/model/network/params.dart';
import '../../../component/http/http_client.dart';
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
      final params =
          Params(langArticles: langArticles, langUI: langUI, page: page);

      final response = await _mobileClient.get(
        '/users?${params.toQueryString()}',
      );

      return UserListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchCard({
    required String login,
    required String langUI,
    required String langArticles,
  }) async {
    try {
      final params = Params(langArticles: langArticles, langUI: langUI);

      final response = await _mobileClient.get(
        '/users/$login/card?${params.toQueryString()}',
      );

      return response.data;
    } on DisplayableException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchWhois({
    required String login,
    required String langUI,
    required String langArticles,
  }) async {
    try {
      final params = Params(langArticles: langArticles, langUI: langUI);

      final response = await _mobileClient.get(
        '/users/$login/whois?${params.toQueryString()}',
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
}
