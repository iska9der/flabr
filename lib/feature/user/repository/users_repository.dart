import '../../../common/exception/displayable_exception.dart';
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
      final response = await _client.get(
        '/users?page=$page&fl=$langArticles&hl=$langUI',
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
      final response = await _client.get(
        '/users/$login/card?fl=$langArticles&hl=$langUI',
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
      final response = await _client.get(
        '/users/$login/whois?fl=$langArticles&hl=$langUI',
      );

      return response.data;
    } on DisplayableException {
      rethrow;
    }
  }
}
