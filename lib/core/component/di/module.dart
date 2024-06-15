import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/repository/part.dart';
import '../../constants/part.dart';
import '../http/part.dart';
import '../storage/part.dart';

@module
abstract class RegisterModule {
  @FactoryMethod()
  Dio get dio => Dio();

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
        dio..options = BaseOptions(baseUrl: mobileApiUrl),
        tokenRepository: repository,
      );

  @Named('siteClient')
  @Singleton()
  HttpClient siteClient(Dio dio, TokenRepository repository) => HabraClient(
        dio..options = BaseOptions(baseUrl: siteApiUrl),
        tokenRepository: repository,
      );

  @Named('ya300client')
  @Singleton()
  HttpClient summaryClient(Dio dio, SummaryTokenRepository repository) =>
      SummaryClient(dio, tokenRepository: repository);
}
