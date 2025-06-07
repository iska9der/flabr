import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ya_summary/ya_summary.dart';

import '../core/component/http/http.dart';
import '../core/component/storage/storage.dart';
import '../core/constants/constants.dart';
import '../data/repository/repository.dart';

@module
abstract class RegisterModule {
  @FactoryMethod()
  Dio get dio => Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // ignore: invalid_annotation_target
  @preResolve
  Future<SharedPreferences> get sharedInstance =>
      SharedPreferences.getInstance();

  @Named('sharedStorage')
  @Singleton()
  CacheStorage sharedStorage(SharedPreferences instance) =>
      SharedStorage(instance);

  @Named('secureStorage')
  @Singleton()
  CacheStorage get secureStorage => SecureStorage(const FlutterSecureStorage());

  @preResolve
  @Singleton()
  Future<CookieJar> cookieManager() async {
    if (kIsWeb) {
      return CookieJar();
    }

    final appDir = await getApplicationDocumentsDirectory();
    final cookieJar = PersistCookieJar(
      storage: FileStorage('${appDir.path}/cookies'),
    );

    return cookieJar;
  }

  @Named('mobileClient')
  @Singleton()
  HttpClient mobileClient(
    Dio dio,
    TokenRepository repository,
    LanguageRepository languageRepository,
  ) => HabraClient(
    dio..options = dio.options.copyWith(baseUrl: Urls.mobileApiUrl),
    tokenRepository: repository,
    languageRepository: languageRepository,
  )..init();

  @Named('siteClient')
  @Singleton()
  HttpClient siteClient(
    Dio dio,
    TokenRepository repository,
    LanguageRepository languageRepository,
  ) => HabraClient(
    dio..options = dio.options.copyWith(baseUrl: Urls.siteApiUrl),
    tokenRepository: repository,
    languageRepository: languageRepository,
  )..init();

  @Singleton()
  SummaryClient summaryClient(Dio dio, SummaryTokenRepository repository) =>
      SummaryClient(dio, tokenRepository: repository);
}
