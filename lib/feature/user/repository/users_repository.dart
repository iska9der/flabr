import '../../../common/exception/displayable_exception.dart';
import '../../../common/model/network/params.dart';
import '../../../component/http/http_client.dart';
import '../model/users_response.dart';

class UsersRepository {
  const UsersRepository(this._client);

  final HttpClient _client;

  Future<UsersResponse> fetchAll({
    required String langUI,
    required String langArticles,
    required String page,
  }) async {
    try {
      final params = Params(fl: langArticles, hl: langUI, page: page);

      final response = await _client.get(
        '/users?${params.toQueryString()}',
      );

      return UsersResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchByLogin({
    required String login,
    required String langUI,
    required String langArticles,
  }) async {
    try {
      final params = Params(fl: langArticles, hl: langUI);

      final response = await _client.get(
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
      final params = Params(fl: langArticles, hl: langUI);

      final response = await _client.get(
        '/users/$login/whois?${params.toQueryString()}',
      );

      return response.data;
    } on DisplayableException {
      rethrow;
    }
  }
}
