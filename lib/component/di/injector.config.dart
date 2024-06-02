// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app_links/app_links.dart' as _i5;
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../common/utils/utils.dart' as _i4;
import '../../data/repository/repository_part.dart' as _i9;
import '../../data/service/service_part.dart' as _i12;
import '../../feature/summary/data/summary_repository.dart' as _i14;
import '../../feature/summary/data/summary_service.dart' as _i13;
import '../../feature/summary/data/summary_token_repository.dart' as _i8;
import '../../feature/summary/summary.dart' as _i11;
import '../http/http_part.dart' as _i10;
import '../router/app_router.dart' as _i7;
import '../storage/storage_part.dart' as _i6;
import 'module.dart' as _i15;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.factory<_i3.Dio>(() => registerModule.dio);
  gh.singleton<_i4.Utils>(() => const _i4.Utils());
  gh.singleton<_i5.AppLinks>(() => registerModule.appLinks);
  gh.singleton<_i6.CacheStorage>(() => registerModule.secureStorage);
  gh.singleton<_i7.AppRouter>(() => _i7.AppRouter());
  gh.singleton<_i8.SummaryTokenRepository>(
      () => _i8.SummaryTokenRepositoryImpl(gh<_i6.CacheStorage>()));
  gh.singleton<_i9.TokenRepository>(
      () => _i9.TokenRepository(gh<_i6.CacheStorage>()));
  gh.singleton<_i9.LanguageRepository>(
      () => _i9.LanguageRepository(storage: gh<_i6.CacheStorage>()));
  gh.singleton<_i10.HttpClient>(
    () => registerModule.summaryClient(
      gh<_i3.Dio>(),
      gh<_i11.SummaryTokenRepository>(),
    ),
    instanceName: 'ya300client',
  );
  gh.singleton<_i10.HttpClient>(
    () => registerModule.mobileClient(
      gh<_i3.Dio>(),
      gh<_i9.TokenRepository>(),
    ),
    instanceName: 'mobileClient',
  );
  gh.singleton<_i12.AuthService>(() => _i12.AuthServiceImpl(
      mobileClient: gh<_i10.HttpClient>(instanceName: 'mobileClient')));
  gh.singleton<_i10.HttpClient>(
    () => registerModule.siteClient(gh<_i9.TokenRepository>()),
    instanceName: 'siteClient',
  );
  gh.lazySingleton<_i12.HubService>(() => _i12.HubServiceImpl(
        mobileClient: gh<_i10.HttpClient>(instanceName: 'mobileClient'),
        siteClient: gh<_i10.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.singleton<_i9.AuthRepository>(
      () => _i9.AuthRepository(gh<_i12.AuthService>()));
  gh.lazySingleton<_i12.SearchService>(() => _i12.SearchServiceImpl(
      gh<_i10.HttpClient>(instanceName: 'mobileClient')));
  gh.lazySingleton<_i13.SummaryService>(() => _i13.SummaryServiceImpl(
      gh<_i10.HttpClient>(instanceName: 'ya300client')));
  gh.lazySingleton<_i14.SummaryRepository>(
      () => _i14.SummaryRepositoryImpl(gh<_i13.SummaryService>()));
  gh.lazySingleton<_i12.UserService>(() => _i12.UserServiceImpl(
        mobileClient: gh<_i10.HttpClient>(instanceName: 'mobileClient'),
        siteClient: gh<_i10.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.lazySingleton<_i9.HubRepository>(
      () => _i9.HubRepository(gh<_i12.HubService>()));
  gh.lazySingleton<_i9.SearchRepository>(
      () => _i9.SearchRepository(gh<_i12.SearchService>()));
  gh.lazySingleton<_i9.UserRepository>(
      () => _i9.UserRepository(gh<_i12.UserService>()));
  gh.lazySingleton<_i12.CompanyService>(() => _i12.CompanyServiceImpl(
        mobileClient: gh<_i10.HttpClient>(instanceName: 'mobileClient'),
        siteClient: gh<_i10.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.lazySingleton<_i12.PublicationService>(() => _i12.PublicationServiceImpl(
        mobileClient: gh<_i10.HttpClient>(instanceName: 'mobileClient'),
        siteClient: gh<_i10.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.lazySingleton<_i9.CompanyRepository>(
      () => _i9.CompanyRepository(gh<_i12.CompanyService>()));
  gh.lazySingleton<_i9.PublicationRepository>(
      () => _i9.PublicationRepository(gh<_i12.PublicationService>()));
  return getIt;
}

class _$RegisterModule extends _i15.RegisterModule {}
