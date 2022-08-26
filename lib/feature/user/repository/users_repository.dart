import '../../../common/exception/displayable_exception.dart';
import '../../../component/http/http_client.dart';
import '../model/users_response.dart';

class UsersRepository {
  const UsersRepository(this._client);

  final HttpClient _client;

  Future<UsersResponse> fetchAll({
    required String langUI,
    required String langPosts,
    required String page,
  }) async {
    try {
      final response = await _client.get(
        '/users?page=$page&fl=$langPosts&hl=$langUI',
      );

      return UsersResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchByLogin(String login) async {
    try {
      final response = await _client.get('/users/$login/card');

      return response.data;
    } on DisplayableException {
      rethrow;
    }
  }
}
