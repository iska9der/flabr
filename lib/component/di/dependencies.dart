import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../common/utils/utils.dart';
import '../../config/constants.dart';
import '../../feature/article/repository/article_repository.dart';
import '../../feature/article/service/article_service.dart';
import '../../feature/auth/repository/auth_repository.dart';
import '../../feature/auth/service/auth_service.dart';
import '../../feature/auth/service/token_service.dart';
import '../../feature/hub/repository/hub_repository.dart';
import '../../feature/hub/service/hub_service.dart';
import '../../feature/search/repository/search_repository.dart';
import '../../feature/search/service/search_service.dart';
import '../../feature/user/repository/user_repository.dart';
import '../../feature/user/service/user_service.dart';
import '../http/http_client.dart';
import '../router/app_router.dart';
import '../storage/cache_storage.dart';

final getIt = GetIt.instance;

void setDependencies() {
  /// Router
  getIt.registerSingleton<AppRouter>(AppRouter());
  getIt.registerSingleton<AppLinks>(AppLinks());

  /// Utils
  getIt.registerSingleton<Utils>(Utils(router: getIt()));

  /// Cache
  getIt.registerSingleton<CacheStorage>(CacheStorage(
    const FlutterSecureStorage(),
  ));

  /// Token
  getIt.registerLazySingleton<TokenService>(
    () => TokenService(getIt()),
  );

  /// Http Clients
  getIt.registerLazySingleton<HttpClient>(
    () => HttpClient(
      Dio(BaseOptions(baseUrl: baseApiUrl)),
      tokenService: getIt(),
    ),
    instanceName: 'baseClient',
  );

  /// proxyClient использует api чувачка jarvis394,
  /// который любезно разрешил пользоваться им при
  /// реализации авторизации
  getIt.registerLazySingleton<HttpClient>(
    () => HttpClient(Dio(BaseOptions(baseUrl: proxyApiUrl))),
    instanceName: 'proxyClient',
  );

  /// Auth
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt(instanceName: 'proxyClient')),
  );
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(getIt()),
  );

  /// Articles
  getIt.registerLazySingleton<ArticleRepository>(
    () => ArticleRepository(getIt(instanceName: 'baseClient')),
  );
  getIt.registerLazySingleton<ArticleService>(
    () => ArticleService(getIt()),
  );

  /// Users
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(getIt(instanceName: 'baseClient')),
  );
  getIt.registerLazySingleton<UserService>(
    () => UserService(getIt()),
  );

  /// Hubs
  getIt.registerLazySingleton<HubRepository>(
    () => HubRepository(getIt(instanceName: 'baseClient')),
  );
  getIt.registerLazySingleton<HubService>(
    () => HubService(getIt()),
  );

  /// Search
  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepository(getIt(instanceName: 'baseClient')),
  );
  getIt.registerLazySingleton<SearchService>(
    () => SearchService(getIt()),
  );
}
