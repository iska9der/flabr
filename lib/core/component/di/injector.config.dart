// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i4;

import '../../../data/repository/part.dart' as _i8;
import '../../../data/service/part.dart' as _i10;
import '../../../presentation/utils/utils.dart' as _i6;
import '../http/part.dart' as _i9;
import '../router/app_router.dart' as _i5;
import '../storage/part.dart' as _i7;
import 'module.dart' as _i11;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.factory<_i3.Dio>(() => registerModule.dio);
  await gh.factoryAsync<_i4.SharedPreferences>(
    () => registerModule.sharedInstance,
    preResolve: true,
  );
  gh.singleton<_i5.AppRouter>(() => _i5.AppRouter());
  gh.singleton<_i6.Utils>(() => const _i6.Utils());
  gh.singleton<_i7.CacheStorage>(
    () => registerModule.sharedStorage(gh<_i4.SharedPreferences>()),
    instanceName: 'sharedStorage',
  );
  gh.singleton<_i8.LanguageRepository>(() => _i8.LanguageRepository(
      storage: gh<_i7.CacheStorage>(instanceName: 'sharedStorage')));
  gh.singleton<_i7.CacheStorage>(
    () => registerModule.secureStorage,
    instanceName: 'secureStorage',
  );
  gh.singleton<_i8.TokenRepository>(() =>
      _i8.TokenRepository(gh<_i7.CacheStorage>(instanceName: 'secureStorage')));
  gh.singleton<_i9.HttpClient>(
    () => registerModule.mobileClient(
      gh<_i3.Dio>(),
      gh<_i8.TokenRepository>(),
    ),
    instanceName: 'mobileClient',
  );
  gh.singleton<_i9.HttpClient>(
    () => registerModule.siteClient(
      gh<_i3.Dio>(),
      gh<_i8.TokenRepository>(),
    ),
    instanceName: 'siteClient',
  );
  gh.singleton<_i8.SummaryTokenRepository>(() => _i8.SummaryTokenRepositoryImpl(
      gh<_i7.CacheStorage>(instanceName: 'secureStorage')));
  gh.singleton<_i9.HttpClient>(
    () => registerModule.summaryClient(
      gh<_i3.Dio>(),
      gh<_i8.SummaryTokenRepository>(),
    ),
    instanceName: 'ya300client',
  );
  gh.lazySingleton<_i10.SearchService>(() =>
      _i10.SearchServiceImpl(gh<_i9.HttpClient>(instanceName: 'mobileClient')));
  gh.lazySingleton<_i10.UserService>(() => _i10.UserServiceImpl(
        mobileClient: gh<_i9.HttpClient>(instanceName: 'mobileClient'),
        siteClient: gh<_i9.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.lazySingleton<_i10.HubService>(() => _i10.HubServiceImpl(
        mobileClient: gh<_i9.HttpClient>(instanceName: 'mobileClient'),
        siteClient: gh<_i9.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.lazySingleton<_i10.PublicationService>(() => _i10.PublicationServiceImpl(
        mobileClient: gh<_i9.HttpClient>(instanceName: 'mobileClient'),
        siteClient: gh<_i9.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.lazySingleton<_i8.PublicationRepository>(
      () => _i8.PublicationRepository(gh<_i10.PublicationService>()));
  gh.lazySingleton<_i8.SearchRepository>(
      () => _i8.SearchRepository(gh<_i10.SearchService>()));
  gh.lazySingleton<_i10.TrackerService>(() => _i10.TrackerServiceImpl(
      siteClient: gh<_i9.HttpClient>(instanceName: 'siteClient')));
  gh.singleton<_i10.AuthService>(() => _i10.AuthServiceImpl(
        siteClient: gh<_i9.HttpClient>(instanceName: 'siteClient'),
        mobileClient: gh<_i9.HttpClient>(instanceName: 'mobileClient'),
      ));
  gh.singleton<_i8.TrackerRepository>(
      () => _i8.TrackerRepositoryImpl(gh<_i10.TrackerService>()));
  gh.lazySingleton<_i10.CompanyService>(() => _i10.CompanyServiceImpl(
        mobileClient: gh<_i9.HttpClient>(instanceName: 'mobileClient'),
        siteClient: gh<_i9.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.singleton<_i8.AuthRepository>(
      () => _i8.AuthRepository(gh<_i10.AuthService>()));
  gh.lazySingleton<_i8.CompanyRepository>(
      () => _i8.CompanyRepository(gh<_i10.CompanyService>()));
  gh.lazySingleton<_i10.SummaryService>(() =>
      _i10.SummaryServiceImpl(gh<_i9.HttpClient>(instanceName: 'ya300client')));
  gh.singleton<_i8.SummaryRepository>(
      () => _i8.SummaryRepositoryImpl(gh<_i10.SummaryService>()));
  gh.lazySingleton<_i8.HubRepository>(
      () => _i8.HubRepository(gh<_i10.HubService>()));
  gh.lazySingleton<_i8.UserRepository>(
      () => _i8.UserRepository(gh<_i10.UserService>()));
  return getIt;
}

class _$RegisterModule extends _i11.RegisterModule {}
