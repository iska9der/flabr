import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../common/utils/utils.dart';
import '../../feature/user/repository/users_repository.dart';
import '../../feature/user/service/users_service.dart';
import '../http/http_client.dart';
import '../router/app_router.dart';
import '../storage/cache_storage.dart';
import '../../config/constants.dart';
import '../../feature/article/repository/articles_repository.dart';
import '../../feature/article/service/articles_service.dart';

final getIt = GetIt.instance;

void setDependencies() {
  /// Router
  getIt.registerSingleton<AppRouter>(AppRouter());
  getIt.registerSingleton<AppLinks>(AppLinks());

  /// Utils
  getIt.registerSingleton<Utils>(Utils(router: getIt()));

  /// Http Clients
  getIt.registerLazySingleton<HttpClient>(
    () => HttpClient(Dio(BaseOptions(baseUrl: baseApiUrl))),
    instanceName: 'baseClient',
  );

  /// proxyClient использует api чувачка jarvis394,
  /// который любезно разрешил пользоваться им при
  /// реализации авторизации
  getIt.registerLazySingleton<HttpClient>(
    () => HttpClient(Dio(BaseOptions(baseUrl: proxyApiUrl))),
    instanceName: 'proxyClient',
  );

  /// Cache
  getIt.registerLazySingleton<CacheStorage>(
    () => CacheStorage(const FlutterSecureStorage()),
  );

  /// Articles
  getIt.registerLazySingleton<ArticlesRepository>(
    () => ArticlesRepository(
      getIt(instanceName: 'baseClient'),
      getIt(instanceName: 'proxyClient'),
    ),
  );
  getIt.registerLazySingleton<ArticlesService>(
    () => ArticlesService(getIt()),
  );

  /// Users
  getIt.registerLazySingleton<UsersRepository>(
    () => UsersRepository(getIt(instanceName: 'baseClient')),
  );
  getIt.registerLazySingleton<UsersService>(
    () => UsersService(getIt()),
  );
}
