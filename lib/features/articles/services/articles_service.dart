import 'package:flabr/features/articles/repositories/articles_repository.dart';

class ArticlesService {
  const ArticlesService(this.repository);

  final ArticlesRepository repository;
}
