import '../../../component/http/http_client.dart';

class HubRepository {
  const HubRepository(HttpClient client) : _client = client;

  final HttpClient _client;

  Future fetchAll() async {}
}
