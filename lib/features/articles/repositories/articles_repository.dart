import '../../../components/http/http_client.dart';

class ArticlesRepository {
  const ArticlesRepository(this.client);

  final HttpClient client;
}
