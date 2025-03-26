import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ya_summary/ya_summary.dart';

import '../../../data/repository/repository.dart';
import '../../constants/constants.dart';
import '../http/http.dart';
import '../storage/storage.dart';

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

  @Named('mobileClient')
  @Singleton()
  HttpClient mobileClient(Dio dio, TokenRepository repository) => HabraClient(
    dio..options = dio.options.copyWith(baseUrl: Urls.mobileApiUrl),
    tokenRepository: repository,
  );

  @Named('siteClient')
  @Singleton()
  HttpClient siteClient(Dio dio, TokenRepository repository) => HabraClient(
    dio..options = dio.options.copyWith(baseUrl: Urls.siteApiUrl),
    tokenRepository: repository,
  );

  @Singleton()
  SummaryClient summaryClient(Dio dio, SummaryTokenRepository repository) =>
      SummaryClient(dio, tokenRepository: repository);
}
