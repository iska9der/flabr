import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../config/constants.dart';
import '../../feature/auth/repository/token_repository.dart';
import '../../feature/auth/service/auth_service.dart';
import '../../feature/company/service/company_service.dart';
import '../../feature/hub/service/hub_service.dart';
import '../../feature/publication/service/publication_service.dart';
import '../../feature/search/service/search_service.dart';
import '../../feature/summary/component/summary_client.dart';
import '../../feature/summary/repository/summary_token_repository.dart';
import '../../feature/summary/service/summary_service.dart';
import '../../feature/user/service/user_service.dart';
import '../http/habra_client.dart';
import '../http/http_client.dart';
import '../storage/cache_storage.dart';

@module
abstract class RegisterModule {
  @FactoryMethod()
  Dio get dio => Dio();

  @Singleton()
  AppLinks get appLinks => AppLinks();

  @Singleton()
  CacheStorage get secureStorage => CacheStorage(const FlutterSecureStorage());

  @Named('mobileClient')
  @Singleton()
  HttpClient mobileClient(Dio dio, TokenRepository repository) => HabraClient(
        dio..options = BaseOptions(baseUrl: mobileApiUrl),
        tokenRepository: repository,
      );

  @Named('siteClient')
  @Singleton()
  HttpClient siteClient(TokenRepository repository) => HabraClient(
        dio..options = BaseOptions(baseUrl: siteApiUrl),
        tokenRepository: repository,
      );

  @Singleton()
  AuthService authService(@Named('mobileClient') HttpClient client) =>
      AuthService(mobileClient: client);

  @LazySingleton()
  PublicationService publicationService(
    @Named('mobileClient') HttpClient mobile,
    @Named('siteClient') HttpClient site,
  ) =>
      PublicationService(
        mobileClient: mobile,
        siteClient: site,
      );

  @LazySingleton()
  UserService userService(
    @Named('mobileClient') HttpClient mobile,
    @Named('siteClient') HttpClient site,
  ) =>
      UserService(
        mobileClient: mobile,
        siteClient: site,
      );

  @LazySingleton()
  HubService hubService(
    @Named('mobileClient') HttpClient mobile,
    @Named('siteClient') HttpClient site,
  ) =>
      HubService(
        mobileClient: mobile,
        siteClient: site,
      );

  @LazySingleton()
  CompanyService companyService(
    @Named('mobileClient') HttpClient mobile,
    @Named('siteClient') HttpClient site,
  ) =>
      CompanyService(
        mobileClient: mobile,
        siteClient: site,
      );

  @LazySingleton()
  SearchService searchService(@Named('mobileClient') HttpClient mobile) =>
      SearchService(mobile);

  @Named('ya300client')
  @Singleton()
  HttpClient summaryClient(Dio dio, SummaryTokenRepository repository) =>
      SummaryClient(dio, tokenRepository: repository);

  @LazySingleton()
  SummaryService summaryService(@Named('ya300client') HttpClient client) =>
      SummaryService(client: client);
}
