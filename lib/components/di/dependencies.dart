import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../common/utils/utils.dart';
import '../http/http_client.dart';
import '../router/router.gr.dart';
import '../storage/cache_storage.dart';
import '../../config/constants.dart';
import '../../feature/article/repository/article_repository.dart';
import '../../feature/article/service/article_service.dart';

final getIt = GetIt.instance;

void setDependencies() {
  getIt.registerSingleton<AppRouter>(AppRouter());

  getIt.registerSingleton<Utils>(Utils(router: getIt()));

  getIt.registerLazySingleton<HttpClient>(
    () => HttpClient(Dio(BaseOptions(baseUrl: baseApiUrl))),
    instanceName: 'baseClient',
  );

  getIt.registerLazySingleton<HttpClient>(
    () => HttpClient(Dio(BaseOptions(baseUrl: proxyApiUrl))),
    instanceName: 'proxyClient',
  );

  getIt.registerLazySingleton<CacheStorage>(
    () => CacheStorage(const FlutterSecureStorage()),
  );

  getIt.registerLazySingleton<ArticleRepository>(
    () => ArticleRepository(
      getIt(instanceName: 'baseClient'),
      getIt(instanceName: 'proxyClient'),
    ),
  );
  getIt.registerLazySingleton<ArticleService>(
    () => ArticleService(getIt()),
  );
}
