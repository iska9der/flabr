import 'package:dio/dio.dart';
import 'package:flabr/components/http/http_client.dart';
import 'package:flabr/components/router/router.gr.dart';
import 'package:flabr/feature/article/repository/article_repository.dart';
import 'package:flabr/feature/article/service/article_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setDependencies() {
  getIt.registerSingleton<AppRouter>(AppRouter());

  getIt.registerLazySingleton<HttpClient>(
    () => HttpClient(Dio()),
  );

  getIt.registerLazySingleton<ArticleRepository>(
    () => ArticleRepository(getIt()),
  );
  getIt.registerLazySingleton<ArticleService>(
    () => ArticleService(getIt()),
  );
}
