// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app_links/app_links.dart' as _i6;
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i4;

import '../../../data/repository/part.dart' as _i9;
import '../../../data/service/part.dart' as _i11;
import '../../../presentation/utils/utils.dart' as _i5;
import '../http/part.dart' as _i10;
import '../router/app_router.dart' as _i7;
import '../storage/part.dart' as _i8;
import 'module.dart' as _i12;

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
  gh.singleton<_i5.Utils>(() => const _i5.Utils());
  gh.singleton<_i6.AppLinks>(() => registerModule.appLinks);
  gh.singleton<_i7.AppRouter>(() => _i7.AppRouter());
  gh.singleton<_i8.CacheStorage>(
    () => registerModule.sharedStorage(gh<_i4.SharedPreferences>()),
    instanceName: 'sharedStorage',
  );
  gh.singleton<_i9.LanguageRepository>(() => _i9.LanguageRepository(
      storage: gh<_i8.CacheStorage>(instanceName: 'sharedStorage')));
  gh.singleton<_i8.CacheStorage>(
    () => registerModule.secureStorage,
    instanceName: 'secureStorage',
  );
  gh.singleton<_i9.TokenRepository>(() =>
      _i9.TokenRepository(gh<_i8.CacheStorage>(instanceName: 'secureStorage')));
  gh.singleton<_i10.HttpClient>(
    () => registerModule.mobileClient(
      gh<_i3.Dio>(),
      gh<_i9.TokenRepository>(),
    ),
    instanceName: 'mobileClient',
  );
  gh.singleton<_i10.HttpClient>(
    () => registerModule.siteClient(
      gh<_i3.Dio>(),
      gh<_i9.TokenRepository>(),
    ),
    instanceName: 'siteClient',
  );
  gh.singleton<_i9.SummaryTokenRepository>(() => _i9.SummaryTokenRepositoryImpl(
      gh<_i8.CacheStorage>(instanceName: 'secureStorage')));
  gh.singleton<_i10.HttpClient>(
    () => registerModule.summaryClient(
      gh<_i3.Dio>(),
      gh<_i9.SummaryTokenRepository>(),
    ),
    instanceName: 'ya300client',
  );
  gh.lazySingleton<_i11.SearchService>(() => _i11.SearchServiceImpl(
      gh<_i10.HttpClient>(instanceName: 'mobileClient')));
  gh.lazySingleton<_i11.UserService>(() => _i11.UserServiceImpl(
        mobileClient: gh<_i10.HttpClient>(instanceName: 'mobileClient'),
        siteClient: gh<_i10.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.lazySingleton<_i11.HubService>(() => _i11.HubServiceImpl(
        mobileClient: gh<_i10.HttpClient>(instanceName: 'mobileClient'),
        siteClient: gh<_i10.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.singleton<_i11.AuthService>(() => _i11.AuthServiceImpl(
      mobileClient: gh<_i10.HttpClient>(instanceName: 'mobileClient')));
  gh.lazySingleton<_i11.PublicationService>(() => _i11.PublicationServiceImpl(
        mobileClient: gh<_i10.HttpClient>(instanceName: 'mobileClient'),
        siteClient: gh<_i10.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.lazySingleton<_i9.PublicationRepository>(
      () => _i9.PublicationRepository(gh<_i11.PublicationService>()));
  gh.lazySingleton<_i9.SearchRepository>(
      () => _i9.SearchRepository(gh<_i11.SearchService>()));
  gh.lazySingleton<_i11.CompanyService>(() => _i11.CompanyServiceImpl(
        mobileClient: gh<_i10.HttpClient>(instanceName: 'mobileClient'),
        siteClient: gh<_i10.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.singleton<_i9.AuthRepository>(
      () => _i9.AuthRepository(gh<_i11.AuthService>()));
  gh.lazySingleton<_i9.CompanyRepository>(
      () => _i9.CompanyRepository(gh<_i11.CompanyService>()));
  gh.lazySingleton<_i11.SummaryService>(() => _i11.SummaryServiceImpl(
      gh<_i10.HttpClient>(instanceName: 'ya300client')));
  gh.singleton<_i9.SummaryRepository>(
      () => _i9.SummaryRepositoryImpl(gh<_i11.SummaryService>()));
  gh.lazySingleton<_i9.HubRepository>(
      () => _i9.HubRepository(gh<_i11.HubService>()));
  gh.lazySingleton<_i9.UserRepository>(
      () => _i9.UserRepository(gh<_i11.UserService>()));
  return getIt;
}

class _$RegisterModule extends _i12.RegisterModule {}
