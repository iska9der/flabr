// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../../data/repository/part.dart' as _i47;
import '../../../data/service/part.dart' as _i476;
import '../../../presentation/utils/utils.dart' as _i937;
import '../http/part.dart' as _i476;
import '../router/app_router.dart' as _i81;
import '../storage/part.dart' as _i994;
import 'module.dart' as _i946;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.factory<_i361.Dio>(() => registerModule.dio);
  await gh.factoryAsync<_i460.SharedPreferences>(
    () => registerModule.sharedInstance,
    preResolve: true,
  );
  gh.singleton<_i81.AppRouter>(() => _i81.AppRouter());
  gh.singleton<_i937.Utils>(() => const _i937.Utils());
  gh.singleton<_i994.CacheStorage>(
    () => registerModule.secureStorage,
    instanceName: 'secureStorage',
  );
  gh.singleton<_i47.TokenRepository>(() => _i47.TokenRepository(
      gh<_i994.CacheStorage>(instanceName: 'secureStorage')));
  gh.singleton<_i476.HttpClient>(
    () => registerModule.mobileClient(
      gh<_i361.Dio>(),
      gh<_i47.TokenRepository>(),
    ),
    instanceName: 'mobileClient',
  );
  gh.singleton<_i994.CacheStorage>(
    () => registerModule.sharedStorage(gh<_i460.SharedPreferences>()),
    instanceName: 'sharedStorage',
  );
  gh.singleton<_i476.HttpClient>(
    () => registerModule.siteClient(
      gh<_i361.Dio>(),
      gh<_i47.TokenRepository>(),
    ),
    instanceName: 'siteClient',
  );
  gh.singleton<_i47.SummaryTokenRepository>(() =>
      _i47.SummaryTokenRepositoryImpl(
          gh<_i994.CacheStorage>(instanceName: 'secureStorage')));
  gh.singleton<_i476.HttpClient>(
    () => registerModule.summaryClient(
      gh<_i361.Dio>(),
      gh<_i47.SummaryTokenRepository>(),
    ),
    instanceName: 'ya300client',
  );
  gh.lazySingleton<_i476.SearchService>(() => _i476.SearchServiceImpl(
      gh<_i476.HttpClient>(instanceName: 'mobileClient')));
  gh.lazySingleton<_i476.UserService>(() => _i476.UserServiceImpl(
        mobileClient: gh<_i476.HttpClient>(instanceName: 'mobileClient'),
        siteClient: gh<_i476.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.lazySingleton<_i476.HubService>(() => _i476.HubServiceImpl(
        mobileClient: gh<_i476.HttpClient>(instanceName: 'mobileClient'),
        siteClient: gh<_i476.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.singleton<_i47.LanguageRepository>(() => _i47.LanguageRepository(
      storage: gh<_i994.CacheStorage>(instanceName: 'sharedStorage')));
  gh.lazySingleton<_i476.PublicationService>(() => _i476.PublicationServiceImpl(
        mobileClient: gh<_i476.HttpClient>(instanceName: 'mobileClient'),
        siteClient: gh<_i476.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.lazySingleton<_i47.PublicationRepository>(
      () => _i47.PublicationRepository(gh<_i476.PublicationService>()));
  gh.lazySingleton<_i47.SearchRepository>(
      () => _i47.SearchRepository(gh<_i476.SearchService>()));
  gh.lazySingleton<_i476.TrackerService>(() => _i476.TrackerServiceImpl(
      siteClient: gh<_i476.HttpClient>(instanceName: 'siteClient')));
  gh.singleton<_i476.AuthService>(() => _i476.AuthServiceImpl(
        siteClient: gh<_i476.HttpClient>(instanceName: 'siteClient'),
        mobileClient: gh<_i476.HttpClient>(instanceName: 'mobileClient'),
      ));
  gh.singleton<_i47.TrackerRepository>(
      () => _i47.TrackerRepositoryImpl(gh<_i476.TrackerService>()));
  gh.lazySingleton<_i476.CompanyService>(() => _i476.CompanyServiceImpl(
        mobileClient: gh<_i476.HttpClient>(instanceName: 'mobileClient'),
        siteClient: gh<_i476.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.singleton<_i47.AuthRepository>(
      () => _i47.AuthRepository(gh<_i476.AuthService>()));
  gh.lazySingleton<_i47.CompanyRepository>(
      () => _i47.CompanyRepository(gh<_i476.CompanyService>()));
  gh.lazySingleton<_i476.SummaryService>(() => _i476.SummaryServiceImpl(
      gh<_i476.HttpClient>(instanceName: 'ya300client')));
  gh.singleton<_i47.SummaryRepository>(
      () => _i47.SummaryRepositoryImpl(gh<_i476.SummaryService>()));
  gh.lazySingleton<_i47.HubRepository>(
      () => _i47.HubRepository(gh<_i476.HubService>()));
  gh.lazySingleton<_i47.UserRepository>(
      () => _i47.UserRepository(gh<_i476.UserService>()));
  return getIt;
}

class _$RegisterModule extends _i946.RegisterModule {}
