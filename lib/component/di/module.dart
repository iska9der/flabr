import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../config/constants.dart';
import '../../data/repository/repository_part.dart';
import '../../feature/summary/summary.dart';
import '../http/http_part.dart';
import '../storage/storage_part.dart';

@module
abstract class RegisterModule {
  @FactoryMethod()
  Dio get dio => Dio();

  @Singleton()
  AppLinks get appLinks => AppLinks();

  @Singleton()
  CacheStorage get secureStorage => SecureStorage(const FlutterSecureStorage());

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

  @Named('ya300client')
  @Singleton()
  HttpClient summaryClient(Dio dio, SummaryTokenRepository repository) =>
      SummaryClient(dio, tokenRepository: repository);
}
