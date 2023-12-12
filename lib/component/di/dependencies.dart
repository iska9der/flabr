import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../common/utils/utils.dart';
import '../../config/constants.dart';
import '../../feature/auth/repository/auth_repository.dart';
import '../../feature/auth/repository/token_repository.dart';
import '../../feature/auth/service/auth_service.dart';
import '../../feature/company/repository/company_repository.dart';
import '../../feature/company/service/company_service.dart';
import '../../feature/hub/repository/hub_repository.dart';
import '../../feature/hub/service/hub_service.dart';
import '../../feature/publication/repository/publication_repository.dart';
import '../../feature/publication/service/publication_service.dart';
import '../../feature/search/repository/search_repository.dart';
import '../../feature/search/service/search_service.dart';
import '../../feature/settings/repository/language_repository.dart';
import '../../feature/summary/component/summary_client.dart';
import '../../feature/summary/repository/summary_repository.dart';
import '../../feature/summary/repository/summary_token_repository.dart';
import '../../feature/summary/service/summary_service.dart';
import '../../feature/user/repository/user_repository.dart';
import '../../feature/user/service/user_service.dart';
import '../http/habra_client.dart';
import '../http/http_client.dart';
import '../router/app_router.dart';
import '../storage/cache_storage.dart';

final getIt = GetIt.instance;

void setDependencies() {
  /// Router
  getIt.registerSingleton<AppRouter>(AppRouter());
  getIt.registerSingleton<AppLinks>(AppLinks());

  /// Utils
  getIt.registerSingleton<Utils>(const Utils());

  /// Cache
  getIt.registerSingleton<CacheStorage>(CacheStorage(
    const FlutterSecureStorage(),
  ));

  /// Token
  getIt.registerSingleton<TokenRepository>(
    TokenRepository(getIt()),
  );
  getIt.registerSingleton<SummaryTokenRepository>(
    SummaryTokenRepository(getIt()),
  );

  /// Http Clients
  getIt.registerSingleton<HttpClient>(
    instanceName: 'mobileClient',
    HabraClient(
      Dio(BaseOptions(baseUrl: mobileApiUrl)),
      tokenRepository: getIt(),
    ),
  );
  getIt.registerSingleton<HttpClient>(
    instanceName: 'siteClient',
    HabraClient(
      Dio(BaseOptions(baseUrl: siteApiUrl)),
      tokenRepository: getIt(),
    ),
  );

  /// Settings
  getIt.registerSingleton<LanguageRepository>(
    LanguageRepository(storage: getIt()),
  );

  /// Auth
  getIt.registerSingleton<AuthService>(
    AuthService(
      mobileClient: getIt(instanceName: 'mobileClient'),
    ),
  );
  getIt.registerSingleton<AuthRepository>(
    AuthRepository(getIt()),
  );

  /// Articles
  getIt.registerLazySingleton<PublicationService>(
    () => PublicationService(
      mobileClient: getIt(instanceName: 'mobileClient'),
      siteClient: getIt(instanceName: 'siteClient'),
    ),
  );
  getIt.registerLazySingleton<PublicationRepository>(
    () => PublicationRepository(getIt()),
  );

  /// Users
  getIt.registerLazySingleton<UserService>(
    () => UserService(
      mobileClient: getIt(instanceName: 'mobileClient'),
      siteClient: getIt(instanceName: 'siteClient'),
    ),
  );
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(getIt()),
  );

  /// Hubs
  getIt.registerLazySingleton<HubService>(
    () => HubService(
      mobileClient: getIt(instanceName: 'mobileClient'),
      siteClient: getIt(instanceName: 'siteClient'),
    ),
  );
  getIt.registerLazySingleton<HubRepository>(
    () => HubRepository(getIt()),
  );

  /// Companies
  getIt.registerLazySingleton<CompanyService>(
    () => CompanyService(
      mobileClient: getIt(instanceName: 'mobileClient'),
      siteClient: getIt(instanceName: 'siteClient'),
    ),
  );
  getIt.registerLazySingleton<CompanyRepository>(
    () => CompanyRepository(getIt()),
  );

  /// Search
  getIt.registerLazySingleton<SearchService>(
    () => SearchService(getIt(instanceName: 'mobileClient')),
  );
  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepository(getIt()),
  );

  /// Summary
  getIt.registerSingleton<HttpClient>(
    instanceName: 'ya300client',
    SummaryClient(Dio(), tokenRepository: getIt()),
  );
  getIt.registerLazySingleton<SummaryService>(
    () => SummaryService(client: getIt(instanceName: 'ya300client')),
  );
  getIt.registerLazySingleton<SummaryRepository>(
      () => SummaryRepository(getIt()));
}
